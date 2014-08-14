function [ total_reward,steps,Q,trace,Pri,Pbi,Vri,Vbi,fitness,Vavg,Vth,time_,faults] = Episode( maxDistance, Q,Qs,Qt, alpha, gamma,epsilon,p,statelist,actionlist,dt,Ts,Vth,Rmin,ro_max, lambda, trace, NOISE)
%Dribbling1d do one episode  with sarsa learning              
% maxDistance: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

% Dribbling1d with SARSA 

Voffset = 20; %Offset Speed in mm/s

NoiseRobotVel = NOISE*0.1; % 7%
NoiseBall = NOISE*0.2; %  50%
NoisePerception = NOISE*0.0025; %  

%NoiseRobotVel=NoiseRobotVel/(Ts/dt);
%NoiseBall=NoiseBall/(Ts/dt);

Pr = 0; % initial position of robot
Pb = 1000; % initial position of ball
Vb = 0; % initial ball velocity
Vr = Voffset; % initial velocity of robot
ro = Pb-Pr;
%psi = Pt-Pb;

x            = [Pr,Pb,Vb,Vr];
xp            = x;
steps        = 0;
total_reward = 0;
fitness = 0;

% convert the continous state variables to an index of the statelist
s   = DiscretizeState(x,statelist);
% selects an action using the epsilon greedy selection strategy
a   = e_greedy_selection(Qs,s,0);

Vavg=0;
time=0;
faults=0;

%for i=1:maxsteps    
 while 1        
    % convert the index of the action into an action value
    action = actionlist(a);    
    
    % Updating kinematincs model
    %action = action/(Ts/dt);
     
    
    %do the selected action and get the next  state    
    [xp x_obs] = DoAction(action, xp, dt, NoiseBall, NoiseRobotVel, NoisePerception, Voffset);    
    
    time = time + dt;
    Vavg=xp(1)/time;
    
      
    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(x_obs,maxDistance,time,Vth,Rmin,ro_max);
    
    
    total_reward = total_reward + r;
           
    % convert the continous state variables in [xp] to an index of the statelist    
    sp  = DiscretizeState(x_obs,statelist);
    
    % select action prime
    ap = e_greedy_selection(Q,sp,epsilon);
    %ap = softmax_selection(Q,sp,epsilon);
    
    %ap = p_source_selection(Q,sp,epsilon,Qs,p);
    p=p*0.99;
    
    % Update the Qtable, that is,  learn from the experience
    %Q = UpdateSARSA( s, a, r, sp, ap, Q , alpha, gamma );
    [Q Qt trace] = UpdateSARSAlambda( s, a, r, sp, ap, Q,Qs,Qt, alpha, gamma, lambda, trace );
    
    
    %update the current variables
    s = sp;
    a = ap;
    x = xp;
    
    pho=(xp(2)-xp(1));
    fitness = fitness + pho/xp(4);
    if pho>ro_max
        faults = faults+1; 
    end
    
    
    %increment the step counter.
    steps=steps+1;
    Pri(steps,1)=x(1); %Pr;
    Pbi(steps,1)=x(2); %Pb;
    Vbi(steps,1)=x(3); %Vb;
    Vri(steps,1)=x(4); %Vr;
    time_(steps,1)=time;
    
    
    % terminal state?
    if (f==true)
        break
    end
      
    
end


