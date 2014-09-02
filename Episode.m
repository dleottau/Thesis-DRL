function [ Vr,ro,fi,gama,Pt,Pb,Pr,Vb,total_reward,steps, Q,Q_y,Q_rot,trace,trace_y,trace_rot, fitness,btd,Vavg,time,faults] = Episode( w, maxDistance, Q,Q_y,Q_rot,Qs, alpha, gamma,epsilon,p, statelist,actionlist,Ts,th_max, lambda, trace,trace_y,trace_rot, NOISE, Q_INIT, V_action_steps)
    

%Dribbling1d do one episode  with sarsa learning              
% maxDistance: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

% Dribbling1d with SARSA 

Voffset = 1; %Offset Speed in mm/s
Vr_max=[100 40 40]; %x,y,rot Max Speed achieved by the robot
Vr_min=-Vr_max;
Vr_min(1)=Voffset;
maxDeltaV = Vr_max.*[1/3 1/3 1/2]; %mm/s/Ts


Vxrmax=100;
Vyrmax=100;
Vthetamax=100;


Pr=[0 0 0];
Pb=[th_max(1)/5 0];
Pt=[maxDistance+1000 0];



NoiseRobotVel = [NOISE*0.15 NOISE*0.05 NOISE*0.03]; %
NoiseBall = [0.1; 0]+NOISE*0.8; %  0.7
NoisePerception = NOISE*0.0025; % 

% ------------- INIT PARAMETERS ---------------------
total_reward = 0;
time(1)=0;
i=1;
Vavg=0;
fitness = 0;
faults=0;
btd=0;

Fr=150;

%Vr(1,1)=Voffset;  
%Vr(1,1)=100;  

Vr(i,:)=[Vr_min(1) 0 0]; %velocidad del robot
Vb(i,1)=0; %velocidad de la bola
dirb(i,1)=atan2(Pb(i,2)-Pr(i,2),Pb(i,1)-Pr(i,1))*180/pi; %dirección bola
[Pr(i,:), Ptr(i,:), Pbr(i,:), alfa, fi(i,1), gama(i,1), ro(i,1), Vb(i,1), dirb(i,1), Pb(i,:)]=mov(Ts,Pr,Pt,Pb,Vr(i,1),Vr(i,2),Vr(i,3),Vxrmax,Vyrmax,Vthetamax,Vb,dirb,Fr, clipDLF(randn(2,1).*NoiseBall,-2,2));
dV=0;

x = [Pr(i,1),Pb(i,1),Vb(i,1),Vr(i,1),ro(i,1),dV,gama(i,1),fi(i,1)];

% Get velocity FLC 
[V_FLC] = FLC_dribbling (w,x,Vr_min,Vr_max);

% convert the continous state variables to an index of the statelist
s   = DiscretizeState(x,statelist);
% selects an action using the epsilon greedy selection strategy
a   = e_greedy_selection(Q,s,epsilon);
a_y = e_greedy_selection(Q_y,s,epsilon);
a_rot = e_greedy_selection(Q_rot,s,epsilon);

ft=[1 1 1];

%for i=1:maxsteps    
 while 1  
    steps=i;
    i = i+1; % OJO, ESTO E SIMPORTANTE PUES SE EVALUAN ESTADOS ANTERIORES, i-1
    time(i) = time(i-1) + Ts; 
         
    % convert the index of the action into an action value
    action = actionlist(a,1);    
    action_y = actionlist(a_y,2);    
    action_rot = actionlist(a_rot,3);    
        
    %-------DO ACTION -----------------
    % do the selected action and get the next  state  
        
    % ADDING SATURATONS AND NOISE
    
    %Vr_ req is the robot speed requested
    %Vr_req=[action action_y action_rot]; 
    Vr_req=[action V_FLC(2) action_rot]; 
    
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
    [V_FLC] = FLC_dribbling (w,x_obs,Vr_min,Vr_max);
    %---------------------------------------        
          
    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(x_obs,maxDistance,th_max,Vr_max,ft,faults/steps*100);
        
    %total_reward = total_reward + r;
    total_reward = total_reward + r;
           
    % convert the continous state variables in [xp] to an index of the statelist    
    sp  = DiscretizeState(x_obs,statelist);
    
    % select action prime
    %ap = e_greedy_selection(Q,sp,epsilon);
    
	a_transf = 1 + round(V_FLC(1)/V_action_steps(1));  % from FLC
    %a_transf_y = 1 + round(V_FLC(2)/V_action_steps(2)) +2;
    a_transf_rot = 1 + round(V_FLC(3)/V_action_steps(3)) +2;
        
    %a_transf=GetBestAction(Qs,1+floor((sp-1)/49));  % from QPho
    %a_transf=GetBestAction(Qs,sp);  % 
    
    p_=1;
    [ap, ft(1)] = p_source_selection_FLC(Q,sp,epsilon,a_transf,p,Q_INIT);
    %[ap_y, ft(2)] = p_source_selection_FLC(Q_y,sp,epsilon,a_transf_y,p_,Q_INIT);
    [ap_rot, ft(3)] = p_source_selection_FLC(Q_rot,sp,epsilon,a_transf_rot,p,Q_INIT);
        
	% Update the Qtable, that is,  learn from the experience
    [Q, trace] = UpdateSARSAlambda( s, a, r(1), sp, ap, Q, alpha, gamma, lambda, trace );
    %[Q_y, trace_y] = UpdateSARSAlambda( s, a_y, r(2), sp, ap_y, Q_y, alpha, gamma, lambda, trace_y );
    [Q_rot, trace_rot] = UpdateSARSAlambda( s, a_rot, r(3), sp, ap_rot, Q_rot, alpha, gamma, lambda, trace_rot );
        
    %update the current variables
    s = sp;
    a = ap;
    %a_y = ap_y;
    a_rot = ap_rot;
            
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
    
    thres = [pho_  abs(gamma_) abs(phi_)] > th_max;
    if sum(thres)~=0
        faults = faults+1;
        fitness = fitness - ( (1-Vrx/Vr_max(1)) + sum(thres .* [pho_  abs(gamma_) abs(phi_)] .*1/th_max) );
    else
        fitness = fitness - (1-Vrx/Vr_max(1));
    end
    
    % terminal state?
    if (f==true || time(i)>1000 || abs(Pr(i,2))>maxDistance/2 || abs(Pb(i,2))>maxDistance/2 )
        Pt(1)=maxDistance;
        btd = (btd + norm(Pt-Pb(i,:))) / (Pt(1)-Pb(1,1));
        fitness = fitness * btd;
        break
    end
      
    
end




