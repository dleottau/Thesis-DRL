function [ RL, Vr,ro,fi,gama,Pt,Pb,Pbi,Pr,Vb,total_reward,steps,Vavg,time,scored,conf] = Episode(RL, conf)
         
%Dribbling1d do one episode  with sarsa learning              
% maxDistance: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

% Dribbling2d with SARSA 

Vr_max = conf.Vr_max; %x,y,rot Max Speed achieved by the robot
Vr_min = conf.Vr_min;
maxDeltaV = conf.maxDeltaV; %mm/s/Ts
%th_max = conf.th_max;
Ts = conf.Ts;
NOISE=conf.NOISE;
maxDistance=conf.maxDistance;

if conf.DRL
    actionlist_x=conf.Actions.x;
    actionlist_w=conf.Actions.w;
else
    actionlist=conf.Actions.cent;
end

trace    = 0*RL.Q;  % the elegibility trace for the vx agent
if conf.DRL
    trace_rot = 0*RL.Q_rot;  % the elegibility trace for the v_rot agent
end
Pr = conf.Pr; 
Pb = conf.Pb; 
Pt = conf.Pt;


NoiseRobotVel = [NOISE*0.15 NOISE*0.03]; %
NoiseBall = [0.0; 0]+NOISE*0.8; %  0.70
NoisePerception = NOISE*0.0025; % 

% ------------- INIT PARAMETERS ---------------------
total_reward = 0;
time(1)=0;
i=1;
Vavg=0;
scored=0;

Fr=15;

Vr(i,:)=[0 0]; %velocidad del robot
Vb(i,1)=0; %velocidad de la bola
dirb(i,1)=atan2(Pb(i,2)-Pr(i,2),Pb(i,1)-Pr(i,1))*180/pi; %dirección bola
[Pr(i,:), Pb(i,:), Vb(i,1), dirb(i,1), ro(i,1), gama(i,1), fi(i,1)]=movDiffRobot(Ts,Pr,Pt,Pb,Vr(i,:),Vb,dirb,Fr, clipDLF(randn(2,1).*NoiseBall,-2,2));
dVb=0;

xG = [Pr(i,1),Pb(i,2),Vb(i,1),Vr(i,1),ro(i,1),dVb,gama(i,1),fi(i,1),Pt(1,1),Pr(i,2),Pb(i,1),Pr(i,3),Vr(i,2)];
x_obs = xG;
X = [x_obs(5), x_obs(7), x_obs(8) x_obs(13)];
X = clipDLF(X, conf.feature_min, conf.feature_max);


[FVx, FVw] = getFeatureVector(X, conf.cores, conf.jointState);
FV=FVw;
% Get velocity From Linear Controller 
[V_FLC] = controller_dribbling (xG,Vr_min,Vr_max);

ballState=0;

% selects an action 
if conf.DRL
    [a, p] = action_selection(RL.Q, RL.T, FVx, RL.param,1);
    [a_rot, p_rot] = action_selection(RL.Q_rot, RL.T_rot, FVw, RL.param,2);
else
    [a, p] = action_selection(RL.Q, RL.T, FV, RL.param,1);
end

U=1;
Qv=0;
RL.param.fa = 0;

while 1  
    steps=i;
    i = i+1; % OJO, ESTO E SIMPORTANTE PUES SE EVALUAN ESTADOS ANTERIORES, i-1
    time(i) = time(i-1) + Ts; 
         
    % convert the index of the action into an action value
    if conf.DRL
        action = actionlist_x(a);    
        action_rot = actionlist_w(a_rot); 
        if conf.fuzzQ
            if conf.Test
                MF=FV/sum(FVx);
                [qv, av] = max(RL.Q,[],2);
                U = sum( MF .* av);
            end
            action = (U-1)*conf.V_action_steps(1);
        end
    else    
        action = actionlist(a,1);   
        action_rot = actionlist(a,2);   % actionlist(a,2);   
    end

    
    %-------DO ACTION -----------------
    % do the selected action and get the next  state  
        
    % ADDING SATURATONS AND NOISE
    
    Vr_req(1)=action; 
    Vr_req(2)=Vr(i-1,2)+action_rot;
       
    %if ballState~=0
    %if ballState==3
    %    Vr_req=[0,0];
    %end
    
    %     Vr_req(1)=V_FLC(1);
    %      Vr_req(2)=0;%V_FLC(2);
    %     Vr_req(3)=V_FLC(3);
%    
    %Vr is the current robot speed
    dVelReq = Vr_req - Vr(i-1,:);
    
    % Vro is the observed speed, without noise
    %Vro = action;
        
    saturation=abs(dVelReq)>maxDeltaV;
    Vr(i,:) = Vr(i-1,:) + sign(dVelReq).*saturation.*maxDeltaV + not(saturation).*dVelReq;
        
    % adding noise in the walking speed, request vs actuator
    Vr(i,:) = Vr(i,:).*(clipDLF(1+0.3*randn(), 1-NoiseRobotVel, 1+NoiseRobotVel));
    % Clip Vx into the permited range
    Vr(i,:) = clipDLF(Vr(i,:),Vr_min,Vr_max); 
        
    % Updating kinematincs model 
    [Pr(i,:), Pb(i,:), Vb(i,1), dirb(i,1), ro(i,1), gama(i,1), fi(i,1)]=movDiffRobot(Ts,Pr(i-1,:),Pt,Pb(i-1,:),Vr(i,:),Vb(i-1,1),dirb(i-1,1),Fr,clipDLF(randn(2,1).*NoiseBall,-2,2));
    dVb=(Vb(i)-Vb(i-1));
    
    
    if dVb>2, ballState = 1; %accelerating
    elseif dVb<-2, ballState = 2; %deaccelerating
    elseif ballState==2 && Vb(i,1)<2
        ballState = 3; % ball stops after it moves
    end
    
    
    % Ground thruth state vector
    xG = [Pr(i,1),Pb(i,2),Vb(i,1),Vr(i,1),ro(i,1),dVb,gama(i,1),fi(i,1),Pt(1,1),Pr(i,2),Pb(i,1),Pr(i,3),Vr(i,2)];
    
    %Adding noise to the ball and target perceptions
    np = (rand()*2*NoisePerception - NoisePerception) + 1;
    % Observed state vector x_obs
    x_obs = xG * np;
    x_obs(1) = xG(1); % x position of the robot , not influenced by noise in perceptions
    x_obs(4) = Vr_req(1); % x speed of the robot , not influenced by noise in perceptions
    
    Xp = [x_obs(5), x_obs(7), x_obs(8), x_obs(13)];
    Xp = clipDLF(Xp, conf.feature_min, conf.feature_max);
    
    % Get velocity From Linear Controller
    [V_FLC] = controller_dribbling (Xp,Vr_min,Vr_max);
    
    
    tic;
    [FVxp, FVwp] = getFeatureVector(Xp, conf.cores, conf.jointState);
    FVp=FVwp;
    
    %---------------------------------------        
          
    % observe the reward at state xp and the final state flag
   
    balline=[Pb(i,:);Pb(i-1,:)];
    goalline=[conf.PgoalPostR; conf.PgoalPostL];
    [checkGoal, Pbi]=goal1(goalline,balline);
    if checkGoal, ballState=3; end

    [r,f]  = GetReward(Xp, Vr_max, conf.feature_max, Pr(i,:), Pb(i,:), Pt, conf.goalSize, maxDistance,checkGoal,Pbi,ballState,Vr(i,:));
    total_reward = total_reward + r;
  
    % select action prime
    
    if conf.DRL
        [ap, fa] = action_selection(RL.Q, RL.T, FVxp, RL.param,1);
        [ap_rot, fa_rot] = action_selection(RL.Q_rot, RL.T_rot, FVwp, RL.param,2);
        fap = min([(fa-1/conf.nactions_x), (fa_rot-1/conf.nactions_w)]); %CAinc
        if conf.MAapproach==1
            fap = 1-fap; %CAdec
        end
        fap = clipDLF(fap, 1E-3, 1);
    else
        [ap, fa] = action_selection(RL.Q, RL.T, FVp, RL.param,1);
    end
    
    if conf.MAapproach~=1 && conf.MAapproach~=3
        fap=1;
    end
                     
	% Update the Qtable, that is,  learn from the experience
    %if ballState==0 || ballState==3
    
    if ~conf.Test
        if conf.DRL % Decentralized
            [RL.Q_rot, trace_rot, RL.T_rot] = UpdateSARSA(FVw, a_rot, r(2), FVwp, ap_rot, RL.Q_rot, trace_rot, RL.param, RL.T_rot, conf.MAapproach);
            if conf.fuzzQ %Fuzzy Q learning
                [ RL.Q, trace, U, Qv] = UpdateQfuzzy(FVx, r(1), RL.Q, trace, RL.param, Qv, 1);
            else % SARSA
                [RL.Q, trace, RL.T] = UpdateSARSA(FVx, a, r(1), FVxp, ap, RL.Q, trace, RL.param, RL.T, conf.MAapproach);
            end
        else % Centralized
            [RL.Q, trace, RL.T] = UpdateSARSA(FV, a, r(1), FVp, ap, RL.Q, trace, RL.param, RL.T, conf.MAapproach);
        end
    end
    conf.timeCounter=conf.timeCounter+toc;    
          
    %update the current variables
    X = Xp;
    a = ap;
    if conf.DRL
        a_rot = ap_rot;
    end
    FV = FVp;
    FVx = FVxp;
    FVw = FVwp;
    RL.param.fa = fap;
                
    %Compute performance index
    Vrx = xG(4);
    pho_ = xG(5);
    gamma_  = xG(7);
    phi_ = xG(8);
    
    xb(i,1) = abs(pho_*cosd(gamma_));
    yb(i,1) = abs(pho_*sind(gamma_));
    yfi(i,1) = abs(pho_*sind(phi_));
    
    %btd = btd + norm(Pb(i,:)-Pb(i-1,:));
    Vavg = xG(1)/time(i);
    
%     thres = [pho_  abs(gamma_) abs(phi_)] > th_max;
%     if sum(thres)~=0
%         faults = faults+1;
%         fitness = fitness - ( (1-Vrx/Vr_max(1)) + sum(thres .* [pho_  abs(gamma_) abs(phi_)] .*1/th_max) );
%     else
%         fitness = fitness - (1-Vrx/Vr_max(1));
%     end
    
    % terminal state?
    if (f==true || time(i)>100 ||  abs(gamma_) > 170   ||  abs(phi_) > 170)
%       Pt(1)=maxDistance;
        %Pbi
        %Pb(i,:)
        if checkGoal
        %if f_ok
            scored = 100;% 100*(1-abs(Pbi(1)-Pt(1))/(conf.goalSize/2));
        end
        break
    end
 
end

end
