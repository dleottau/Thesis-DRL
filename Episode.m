function [ action,Vxr,Vyr,Vtheta,ro,fi,gama,Pt,Pb,Pr,Vb,dV,total_reward,steps,Q,trace,fitness,btd,Vavg,Vth,time,faults,xb,yb,yfi] = Episode( w, maxDistance, Q , alpha, gamma,epsilon,p, statelist,actionlist,Ts,Vth,ro_max, lambda, trace,NOISE)
                                                                                                                         

%Dribbling1d do one episode  with sarsa learning              
% maxDistance: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

% Dribbling1d with SARSA 

Vxrmax=100;
Vyrmax=100;
Vthetamax=100;



Pr=[0 0 0];
Pb=[1000 0];
Pt=[maxDistance+ro_max 0];

maxDeltaVx = 30; %mm/s/Ts
Voffset = 1; %Offset Speed in mm/s

NoiseRobotVel = NOISE*0.15; %
NoiseBall = NOISE*0.8; %  0.7
NoisePerception = NOISE*0.0025; % 

% ------------- INIT PARAMETERS ---------------------
Vavg = 0;
total_reward = 0;
time(1)=0;
i=1;

Fr=150;

Vxr(1,1)=Voffset;  
%Vxr(1,1)=100;  

Vyr=0;   
Vtheta=0;
Vb(1,1)=0; %velocidad de la bola
dirb(1,1)=atan2(Pb(1,2)-Pr(1,2),Pb(1,1)-Pr(1,1))*180/pi; %dirección bola
[Pr(i,:) Ptr(i,:) Pbr(i,:) alfa fi(i,1) gama(i,1) ro(i,1) Vb(i,1) dirb(i,1) Pb(i,:)]=mov(Ts,Pr,Pt,Pb,Vxr,Vyr,Vtheta,Vxrmax,Vyrmax,Vthetamax,Vb,dirb,Fr,randn(2,1)*NoiseBall);
dV=0;

x = [Pr(i,1),Pb(i,1),Vb(i,1),Vxr(i,1),ro(i,1),dV,gama(i,1),fi(i,1)];

% convert the continous state variables to an index of the statelist
s   = DiscretizeState(x,statelist);
% selects an action using the epsilon greedy selection strategy
a   = e_greedy_selection(Q,s,epsilon);

Vavg=0;
fitness = 0;
faults=0;
btd=0;

%for i=1:maxsteps    
 while 1  
    steps=i;
    i = i+1; % OJO, ESTO E SIMPORTANTE PUES SE EVALUAN ESTADOS ANTERIORES, i-1
    time(i) = time(i-1) + Ts; 
         
    % convert the index of the action into an action value
    action = actionlist(a);    
        
    %-------DO ACTION -----------------
    % do the selected action and get the next  state  
    [Vx_FLC, Vyr, Vtheta ] = FLC_dribbling (w,alfa,fi(i-1,1),gama(i-1,1),ro(i-1,1),Voffset);
    
    %Enable Vy and Vtheta for the 1D scenary
    %Vyr=0;
    %Vtheta=0;
    
    % ADDING NOISE
    Vr=Vxr(i-1,1); %current x speed
    %action = Vx_FLC; % Enables the FLC of Vx
    dVelReq = action - Vr;
    % Vro is the observed speed, without noise
    Vro = action;
    % TODO: Extender esta saturación para Vy y Vtheta
    if abs(dVelReq)>maxDeltaVx
        Vr = Vr + sign(dVelReq)*maxDeltaVx;
    else
        Vr = Vr + dVelReq;
    end
    Vr = Vr*(clipDLF(1+0.3*randn(), 1-NoiseRobotVel, 1+NoiseRobotVel)); 
    Vr = clipDLF(Vr,Voffset,Vxrmax); 
    Vxr(i,1)=Vr;
    
    % Updating kinematincs model 
    [Pr(i,:) Ptr(i,:) Pbr(i,:) alfa fi(i,1) gama(i,1) ro(i,1) Vb(i,1) dirb(i,1) Pb(i,:)]=mov(Ts,Pr(i-1,:),Pt,Pb(i-1,:),Vxr(i,1),Vyr,Vtheta,Vxrmax,Vyrmax,Vthetamax,Vb(i-1,1),dirb(i-1,1),Fr,randn(2,1)*NoiseBall);
    dV = Vb(i,1) * cosd( Pr(i,3)-dirb(i,1) ) - Vxr(i,1);
    % Ground thruth state vector
    x = [Pr(i,1),Pb(i,1),Vb(i,1),Vxr(i,1),ro(i,1),dV,gama(i,1),fi(i,1)];

    %Adding noise to the ball and target perceptions
    np = (rand()*2*NoisePerception - NoisePerception) + 1;
    % Observed state vector x_obs
    x_obs = x * np;
    x_obs(1) = x(1); % x position of the robot , not influenced by noise in perceptions
    x_obs(4) = Vro; % x speed of the robot , not influenced by noise in perceptions
    %---------------------------------------        
        
    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(x_obs,maxDistance,time(i),Vth,ro_max);
        
    total_reward = total_reward + r;
           
    % convert the continous state variables in [xp] to an index of the statelist    
    sp  = DiscretizeState(x_obs,statelist);
    
    % select action prime
    ap = e_greedy_selection(Q,sp,epsilon);
    
    % Update the Qtable, that is,  learn from the experience
    [Q, trace] = UpdateSARSAlambda( s, a, r, sp, ap, Q, alpha, gamma, lambda, trace );
        
    %update the current variables
    s = sp;
    a = ap;
            
    %Compute performance index
    %Vr = x(4);
    pho_ = x(5);
    gamma_  = x(7);
    phi_ = x(8);
    
    xb(i,1) = abs(pho_*cosd(gamma_));
    yb(i,1) = abs(pho_*sind(gamma_));
    yfi(i,1) = abs(pho_*sind(phi_));
    
    fitness = fitness + x(5)/x(4);
    btd = btd + norm(Pb(i,:)-Pb(i-1,:));
    Vavg = x(1)/time(i);
    if xb(i,1)>ro_max || yb(i,1)>ro_max/4 || yfi(i,1)>ro_max/4
    %if x(5)>ro_max
        faults = faults+1; 
    end
    
    
    % terminal state?
    if (f==true)
        Pt(1)=Pt(1)-ro_max;
        btd = (btd + norm(Pt-Pb(i,:))) / (Pt(1)-Pb(1,1));
        fitness = fitness * btd;
        break
    end
      
    
end


