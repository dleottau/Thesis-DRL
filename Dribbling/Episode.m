function [ RL, Vr,ro,fi,gama,Pt,Pb,Pr,Vb,total_reward,steps, fitness,btd,Vavg,time,faults,goal] = Episode(RL, conf)
         

%Dribbling1d do one episode  with sarsa learning              
% maxDistance: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

% Dribbling1d with SARSA 

actionlist = conf.Actions;
Vr_max = conf.Vr_max; %x,y,rot Max Speed achieved by the robot
Vr_min = conf.Vr_min;
maxDeltaV = conf.maxDeltaV; %mm/s/Ts
feature_step = conf.feature_step;
V_action_steps = conf.V_action_steps;
cores = conf.cores;
div_disc = conf.div_disc;
th_max = conf.th_max;
Ts = conf.Ts;
NOISE=conf.NOISE;
maxDistance=conf.maxDistance;

Vxrmax=100;
Vyrmax=100;
Vthetamax=100;

Pr=[0 0 0];
Pb=[th_max(1)*0.99 0];
Pt=[maxDistance+2000 0];

NoiseRobotVel = [NOISE*0.15 NOISE*0.05 NOISE*0.03]; %
NoiseBall = [0.12; 0]+NOISE*0.8; %  0.8
NoisePerception = NOISE*0.0025; % 

% ------------- INIT PARAMETERS ---------------------
if conf.TRANSFER>=0
    RL.trace    = 0*RL.trace;
    RL.trace_y  = RL.trace;  % the elegibility trace for the vy agent
    RL.trace_rot = RL.trace;  % the elegibility trace for the v_rot agent
end

total_reward = 0;
time(1)=0;
i=1;
Vavg=0;
fitness = 0;
faults=0;
btd=0;

Fr=150;

rnd.nash=0;
rnd.nashExpl=0;
rnd.expl=0;
rnd.TL=0;

Pa=[0 0 0];
pa = 0;

RL.cum_Pa = [0 0 0];
RL.cum_dPa = [0 0 0];
dpa=0;

Vr(i,:)=[Vr_min(1) 0 0]; %velocidad del robot
Vb(i,1)=0; %velocidad de la bola
dirb(i,1)=atan2(Pb(i,2)-Pr(i,2),Pb(i,1)-Pr(i,1))*180/pi; %dirección bola
[Pr(i,:), Ptr(i,:), Pbr(i,:), alfa, fi(i,1), gama(i,1), ro(i,1), Vb(i,1), dirb(i,1), Pb(i,:)]=mov(Ts,Pr,Pt,Pb,Vr(i,1),Vr(i,2),Vr(i,3),Vxrmax,Vyrmax,Vthetamax,Vb,dirb,Fr, clipDLF(randn(2,1).*NoiseBall,-2,2));
dV=0;

x = [Pr(i,1),Pb(i,1),Vb(i,1),Vr(i,1),ro(i,1),dV,gama(i,1),fi(i,1)];

% Get velocity FLC 
[V_src] = controller (x,Vr_min,Vr_max);

% convert the continous state variables to an index of the statelist
%s   = DiscretizeState(x,statelist);
s  = DiscretizeStateDLF(x,cores,feature_step,div_disc);

% selects an action using the epsilon greedy selection strategy
a(1)   = e_greedy_selection(RL.Q, s, RL.param.epsilon, rand());
a(2) = e_greedy_selection(RL.Q_y,s, RL.param.epsilon, rand());
a(3) = e_greedy_selection(RL.Q_rot,s, RL.param.epsilon, rand());
%action = ones(1,3);
ap(1)=a(1);
ap(2)=a(2);
ap(3)=a(3);


while 1  
    steps=i;
    i = i+1; % OJO, ESTO E SIMPORTANTE PUES SE EVALUAN ESTADOS ANTERIORES, i-1
    time(i) = time(i-1) + Ts; 
         
    % convert the index of the action into an action value
    %action = actionlist(a,:);    
    action(1) = actionlist(a(1),1);    
    action(2) = actionlist(a(2),2);    
    action(3) = actionlist(a(3),3);    
        
    %-------DO ACTION -----------------
    % do the selected action and get the next  state  
        
    % ADDING SATURATONS AND NOISE
    
    %Vr_ req is the robot speed requested
    %Vr_req=action; %centralized learner
    Vr_req=action; 
    %Vr_req(1)=V_FLC(1);
    %Vr_req(2)=V_FLC(2);
    %Vr_req(3)=V_FLC(3);
    
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
    [Pr(i,:), Ptr(i,:), Pbr(i,:), alfa, fi(i,1), gama(i,1), ro(i,1), Vb(i,1), dirb(i,1), Pb(i,:)]=mov(Ts,Pr(i-1,:),Pt,Pb(i-1,:),Vr(i,1),Vr(i,2),Vr(i,3),Vxrmax,Vyrmax,Vthetamax,Vb(i-1,1),dirb(i-1,1),Fr, clipDLF(randn(2,1).*NoiseBall,-2,2));
    dV = Vb(i,1) * cosd( Pr(i,3)-dirb(i,1) ) - Vr(i,1);
    % Ground thruth state vector
    x = [Pr(i,1),Pb(i,1),Vb(i,1),Vr(i,1),ro(i,1),dV,gama(i,1),fi(i,1)];
    
    
    %Adding noise to the ball and target perceptions
    np = (rand()*2*NoisePerception - NoisePerception) + 1;
    % Observed state vector x_obs
    x_obs = x * np;
    x_obs(1) = x(1); % x position of the robot , not influenced by noise in perceptions
    x_obs(4) = Vr_req(1); % x speed of the robot , not influenced by noise in perceptions
    
    % Get velocity FLC 
    [V_src] = controller (x_obs,Vr_min,Vr_max);
    %---------------------------------------        
          
    % observe the reward at state xp and the final state flag
    %x_obs(7)=0;
    %x_obs(8)=0;
    [r,f]   = GetReward(x_obs,maxDistance,th_max,Vr_max,faults/steps*100);
        
    %total_reward = total_reward + r;
    total_reward = total_reward + r;
           
    % convert the continous state variables in [xp] to an index of the statelist    
    %sp  = DiscretizeState(x_obs,statelist);
    sp  = DiscretizeStateDLF(x_obs,cores,feature_step,div_disc);
        
    % Syncronizing exploration and transfer between agents
    if conf.sync.nash, rnd.nash=randn(); end
    if conf.sync.expl, rnd.expl=rand(); end
    if conf.sync.TL, rnd.TL=rand(); end
    
    % Transfer knowledge
    if conf.TRANSFER && conf.nash
        if ~conf.sync.nash, rnd.nash=randn(1,3); end
        if conf.nash==2
            V_src(1)=triang_dist(Vr_min(1),V_src(1),Vr_max(1),RL.param.p,RL.param.aScale);
            V_src(2)=triang_dist(Vr_min(2),V_src(2),Vr_max(2),RL.param.p,RL.param.aScale);
            V_src(3)=triang_dist(Vr_min(3),V_src(3),Vr_max(3),RL.param.p,RL.param.aScale);
        else
            V_src = clipDLF( V_src + ((Vr_max-Vr_min)/RL.param.aScale)*rnd.nash.*(1 - RL.param.p), Vr_min,Vr_max);
        end
    end
      
    V_src = clipDLF( V_src,Vr_min,Vr_max);
    a_transf(1) = 1 + round(V_src(1)/V_action_steps(1));  % from FLC
    a_transf(2) = 1 + round(V_src(2)/V_action_steps(2)  + Vr_max(2)/V_action_steps(2));
    a_transf(3) = 1 + round(V_src(3)/V_action_steps(3) + Vr_max(3)/V_action_steps(3));
        
    % select action prime
    
    % testing beta adaptive
    %pk=RL.param.p
    %RL.param.p = 1-min(Pa);
    %pk1=RL.param.p
    % ----
    
    [ap(1), Pap(1)] = p_source_selection(RL.Q,RL.T,sp,RL.param, a_transf(1), conf.sync, rnd);
    [ap(2), Pap(2)] = p_source_selection(RL.Q_y, RL.T_y, sp, RL.param, a_transf(2), conf.sync, rnd);
    [ap(3), Pap(3)] = p_source_selection(RL.Q_rot, RL.T_rot, sp, RL.param, a_transf(3), conf.sync, rnd);
   
    RL.cum_Pa = RL.cum_Pa + Pap;
    dPa=abs(Pap-Pa);
    RL.cum_dPa = RL.cum_dPa + dPa;
    
    % select MA approach
    pap=1;
    if conf.MAapproach==1
        pap = 1-min(Pa); %CAdec
        %pap = min(Pa); % CAinc
        %pap = clipDLF(pap, 1E-3, 1);
    end
    
    pap = min(Pap);
    pa=1; % temp
    
	% Update the Qtable, that is,  learn from the experience
    if conf.TRANSFER >= 0 %Para aprendizaje, TRANSFER<0 para pruebas de performance
        [RL.Q, RL.trace, RL.T] = UpdateSARSAlambda( s,a(1), r(1), sp, ap(1), RL.Q, RL.param, RL.trace, conf.MAapproach, pa, RL.T);
        [RL.Q_y, RL.trace_y, RL.T_y] = UpdateSARSAlambda( s,a(2), r(2), sp, ap(2), RL.Q_y, RL.param, RL.trace_y, conf.MAapproach, pa, RL.T_y );
        [RL.Q_rot, RL.trace_rot, RL.T_rot] = UpdateSARSAlambda( s,a(3), r(3), sp, ap(3), RL.Q_rot, RL.param, RL.trace_rot, conf.MAapproach, pa, RL.T_rot);
    end    
    %update the current variables
    s = sp;
    a = ap;
    pa = pap;
    Pa=Pap;
    
            
    %Compute performance index
    Vrx = x(4);
    pho_ = x(5);
    gamma_  = x(7);
    phi_ = x(8);
    
    xb(i,1) = abs(pho_*cosd(gamma_));
    yb(i,1) = abs(pho_*sind(gamma_));
    yfi(i,1) = abs(pho_*sind(phi_));
    
    btd = btd + norm(Pb(i,:)-Pb(i-1,:));
    Vavg = x(1)/time(i);
    
    %cumulating amount of faults commited
    thres = [pho_  abs(gamma_) abs(phi_)] > th_max;
    if sum(thres)~=0
        faults = faults+1;
    end
    
    % terminal state?
    goal=0;
    
    %if (conf.TRANSFER >= 0 && (time(i)>100 || abs(Pr(i,2))>maxDistance/2 || abs(Pb(i,2))>maxDistance/2 || Pr(i,1)>maxDistance || Pr(i,1)<0 || Pb(i,1)<0 || abs(gamma_) > 90 || abs(phi_) > 150))
    if (time(i)>1000 || abs(Pr(i,2))>maxDistance/2 || abs(Pb(i,2))>maxDistance/2 || Pr(i,1)>maxDistance || Pr(i,1)<0 || Pb(i,1)<0 || abs(gamma_) > 90 || abs(phi_) > 150)
    Vavg=0;
        break
    end
    
    if (f==true)
        if abs(Pb(i,2))<750
            goal=1;
        end
        break
    end
    
end