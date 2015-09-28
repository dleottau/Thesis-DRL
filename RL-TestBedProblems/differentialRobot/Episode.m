function [ RL, Vr,ro,fi,gama,Pt,Pb,Pbi,Pr,Vb,total_reward,steps,Vavg,time,accuracy] = Episode(RL, conf)
         
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
accuracy=0;

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


FV = getFeatureVector(X, conf.cores);

% Get velocity From Linear Controller 
[V_FLC] = controller_dribbling (xG,Vr_min,Vr_max);

ballState=0;

% selects an action 
[a, p] = action_selection(RL.Q, FV, RL.param);
if conf.DRL
    [a_rot, p_rot] = action_selection(RL.Q_rot, FV, RL.param);
end



while 1  
    steps=i;
    i = i+1; % OJO, ESTO E SIMPORTANTE PUES SE EVALUAN ESTADOS ANTERIORES, i-1
    time(i) = time(i-1) + Ts; 
         
    % convert the index of the action into an action value
    if conf.DRL
        action = actionlist_x(a);    
        action_rot = actionlist_w(a_rot);    
    else    
        action = actionlist(a,1);   
        action_rot = actionlist(a,2);   % actionlist(a,2);   
    end
    
    %-------DO ACTION -----------------
    % do the selected action and get the next  state  
        
    % ADDING SATURATONS AND NOISE
    
    Vr_req(1)=action; 
    Vr_req(2)=Vr(i-1,2)+action_rot;
    
    
    if ballState~=0
    %if ballState==3
        Vr_req=[0,0];
    end
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
    
    FVp = getFeatureVector(Xp, conf.cores);
    
    % Get velocity From Linear Controller
    [V_FLC] = controller_dribbling (Xp,Vr_min,Vr_max);
    %---------------------------------------        
          
    % observe the reward at state xp and the final state flag
    
    balline=[Pb(i,:);Pb(i-1,:)];
    goalline=[conf.PgoalPostR; conf.PgoalPostL];
    [checkGoal, Pbi]=goal1(goalline,balline);
    if checkGoal, ballState=3; end

    [r,f]  = GetReward(Xp, Vr_max, conf.feature_max, Pr(i,:), Pb(i,:), Pt, conf.goalSize, maxDistance,checkGoal,Pbi,ballState,Vr(i,:));
    total_reward = total_reward + r;
   
   
    % select action prime
    [ap, p] = action_selection(RL.Q, FVp, RL.param);
    if conf.DRL
        [ap_rot, p_rot] = action_selection(RL.Q_rot, FVp, RL.param);
    end
  
                     
	% Update the Qtable, that is,  learn from the experience
    if ballState==0 || ballState==3
    
        [RL.Q, trace] = UpdateSARSA(FV, a, r(1), FVp, ap, RL.Q,     trace,     RL.param);
        if conf.DRL
            [RL.Q_rot, trace_rot] = UpdateSARSA(FV, a, r(2), FVp, ap, RL.Q_rot, trace_rot, RL.param);

            % just for debugging
            if sum(sum(RL.Q))==sum(sum(RL.Q_rot))
                ap;
                ap_rot;
            end
            % just for debugging
        end
        
    end
        
          
    %update the current variables
    X = Xp;
    a = ap;
    if conf.DRL
        a_rot = ap_rot;
    end
    FV = FVp;
                
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
    if (f==true || time(i)>60)
%       Pt(1)=maxDistance;
        %Pbi
        %Pb(i,:)
        if checkGoal
        %if f_ok
            accuracy = 1;% 100*(1-abs(Pbi(1)-Pt(1))/(conf.goalSize/2));
        end
        break
    end
    
   
end
 
end
