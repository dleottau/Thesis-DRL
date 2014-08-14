function  [reward fitness Vavg tp_faults Q] =Dribbling1d( maxepisodes, maxDistance, ro_max, NOISE)
%Dribbling1d SARSA, the main function of the trainning
%maxepisodes: maximum number of episodes to run the demo

%  SARSA 

%clc
%clf

% set(gcf,'BackingStore','off')  % for realtime inverse kinematics
% set(gcf,'name','Reinforcement Learning Mountain Car')  % for realtime inverse kinematics
% set(gco,'Units','data')

dt = 0.2;  %sample time of the kinematics model updating
Ts = 1*dt; %Sample time of a RL step
Vth = 60; %60 minimum expected speed of robot @ mm/s
States   = StateTable();  % the table of states
Actions  = ActionTable(); % the table of actions

Rmin=-2;
Rmax=1;

nstates     = size(States,1);
nactions    = size(Actions,1);
Qt           = QTable(nstates,nactions,0);  % the Qtable
load Q_0noise;
%load Q_handC;
%Q=Q_handC;

Qs = Q_0noise;
Q = Qt;

trace = QTable( nstates,nactions,0 );  % the elegibility trace

alpha = 0.1;   % learning rate
gamma = 1;   % discount factor
epsilon0 = 0.2; %0.2 probability of a random action selection
lambda = 0.9;  % the decaying elegibiliy trace parameter
p0=1;

EXPLORATION_STEPS = 10;
epsDec = -log(0.05) * EXPLORATION_STEPS/maxepisodes;  %epsilon decrece a un 5% (0.005) en maxepisodes/EXPLORATION_STEPS, de esta manera el decrecimiento de epsilon es independiente del numero de episodios
epsilon = epsilon0;
p=p0;

xpoints=[];
ypoints=[];


for i=1:maxepisodes    
   
   [total_reward,steps,Q,trace,Pr,Pb,Vr,Vb,fitness_k,Vavg(i),Vth,time_,faults] = Episode( maxDistance, Q,Qs,Qt, alpha, gamma, epsilon,p, States, Actions, dt, Ts, Vth, Rmin, ro_max, lambda, trace, NOISE);
    
    epsilon = epsilon0 * exp(-i*epsDec);
    p = p0*exp(-i*epsDec/5);
       
     xpoints(i)=i-1;
     ypoints(i)=steps;
     reward(i,1)=total_reward/steps;
     fitness(i,1)=fitness_k;
     tp_faults(i,1)=faults/steps*100;

subplot(3,2,1);    
plot(xpoints,reward)      
title([ 'Mean Reward. Episode:',int2str(i),' e=',num2str(epsilon) ])
drawnow

subplot(3,2,3)
plot(xpoints,Vavg)
title('Speed Average')
drawnow

subplot(3,2,5); 
plot(xpoints,fitness)
title('Fitness')
drawnow

subplot(3,2,2);
plot(time_,Pr,'*')
hold on
plot(time_,Pb,'r.')
plot(time_,Pb-Pr,'g')
title('Position')
hold
drawnow

subplot(3,2,4);
plot(time_,Vr)
title('Velocity')
drawnow

subplot(3,2,6);
plot(time_,Vb,'r')
hold on
plot(time_,Vr,'b')
plot(time_,Vb-Vr,'g')
title('Delta Vbr')
hold
drawnow


end

