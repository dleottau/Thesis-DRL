function [ action,Vxr,Vyr,Vtheta,ro,fi,gama,Pt,Pb,Pr,Vb,dV,total_reward,steps,Q,trace,fitness,Vavg,Vth,time,faults] = Episode( w, maxDistance, Q , alpha, gamma,epsilon,p, statelist,actionlist,Ts,Vth,ro_max, lambda, trace,NOISE)
                                                                                                                         

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

Voffset = 20; %Offset Speed in mm/s
NoiseBall= 0.7*NOISE; %  entre 0 y 1
NoiseRobotVel = 0.05*NOISE; %  0.07 =+/-7% del valor actual



% ------------- INIT PARAMETERS ---------------------
Vavg = 0;
total_reward = 0;
steps=1;
time(1)=0;
i=1;

Fr=150;

Vxr(1,1)=Voffset;  
%Vxr(1,1)=100;  

Vyr(1,1)=0;   
Vtheta(1,1)=0;
Vb(1,1)=0; %velocidad de la bola
dirb(1,1)=atan2(Pb(1,2)-Pr(1,2),Pb(1,1)-Pr(1,1))*180/pi; %dirección bola
[Pr(i,:) Ptr(i,:) Pbr(i,:) alfa(i,1) fi(i,1) gama(i,1) ro(i,1) Vb(i,1) dirb(i,1) Pb(i,:)]=mov(Ts,Pr,Pt,Pb,Vxr,Vyr,Vtheta,Vxrmax,Vyrmax,Vthetamax,Vb,dirb,Fr,randn(2,1)*NoiseBall);
dV(1,1)=0;

x            = [Pr(i,1),Pb(i,1),Vb(i,1),Vxr(i,1),ro(i,1),dV(i,1),gama(i,1),fi(i,1)];


% convert the continous state variables to an index of the statelist
s   = DiscretizeState(x,statelist);
% selects an action using the epsilon greedy selection strategy
a   = e_greedy_selection(Q,s,epsilon);

Vavg=0;
fitness = 0;
faults=0;

%for i=1:maxsteps    
 while 1  
    i = i+1; % OJO, ESTO E SIMPORTANTE PUES SE EVALUAN ESTADOS ANTERIORES, i-1
    time(i) = time(i-1) + Ts; 
     
    % convert the index of the action into an action value
    action = actionlist(a);    
    %action=0;
    
    %-------DO ACTION -----------------
    % Updating kinematincs model 
    
    %Vyr(i,1)=0;
    %Vtheta(i,1)=0;
    [ Vx_FLC, Vyr(i,1), Vtheta(i,1) ] = FLC_dribbling (w,alfa(i-1,1),fi(i-1,1),gama(i-1,1),ro(i-1,1),Voffset);
     
    
    %do the selected action and get the next  state
    Vr=Vxr(i-1,1);
    Vr = action;
    Vr = Vr + NoiseRobotVel*Vr*randn(1,1);
        if Vr<Voffset
            Vr = Voffset;
        elseif Vr>100
            Vr = 100;
        end
    Vxr(i,1)=Vr;
    
    %Vxr(i,1)=Vx_FLC;  % descomentar si quiere usar el FLC de Vx
        
    [Pr(i,:) Ptr(i,:) Pbr(i,:) alfa(i,1) fi(i,1) gama(i,1) ro(i,1) Vb(i,1) dirb(i,1) Pb(i,:)]=mov(Ts,Pr(i-1,:),Pt,Pb(i-1,:),Vxr(i,1),Vyr(i,1),Vtheta(i,1),Vxrmax,Vyrmax,Vthetamax,Vb(i-1,1),dirb(i-1,1),Fr,randn(2,1)*NoiseBall);
    dV(i,1) = Vb(i,1) * cosd( Pr(i,3)-dirb(i,1) ) - Vxr(i,1);
    
    xp = [Pr(i,1),Pb(i,1),Vb(i,1),Vxr(i,1),ro(i,1),dV(i,1),gama(i,1),fi(i,1)];
    
        
    %time = time + Ts;
    Vavg=Pr(i,1)/time(i);
    
    %---------------------------------------
    
    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(xp,maxDistance,time(i),Vth,ro_max);
        
    total_reward = total_reward + r;
           
    % convert the continous state variables in [xp] to an index of the statelist    
    sp  = DiscretizeState(xp,statelist);
    
    % select action prime
    ap = e_greedy_selection(Q,sp,epsilon);
    
    % Update the Qtable, that is,  learn from the experience
    [Q, trace] = UpdateSARSAlambda( s, a, r, sp, ap, Q, alpha, gamma, lambda, trace );
        
    %update the current variables
    s = sp;
    a = ap;
    x = xp;
    
    pho=(xp(2)-xp(1));
    fitness = fitness + pho/xp(4);
    if pho>ro_max
        faults = faults+1; 
    end
    
    %increment the step counter. todo esto no es necesario
    steps=steps+1;
    Pri(steps,1)=x(1); %Pr;
    Pbi(steps,1)=x(2); %Pb;
    Vbi(steps,1)=x(3); %Vb;
    Vri(steps,1)=x(4); %Vr;
    
    
    
    % terminal state?
    if (f==true)
        break
    end
      
    
end


