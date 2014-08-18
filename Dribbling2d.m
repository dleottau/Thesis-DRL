function  [reward fitness Vavg tp_faults Q] =Dribbling2d(  DRAWS, maxepisodes, maxDistance, ro_max, NOISE)
%Dribbling1d SARSA, the main function of the trainning
%maxepisodes: maximum number of episodes to run the demo

%  SARSA 

%clc
%clf

load W-FLC;
%load ene11;

%dt = 0.2;  %sample time of the kinematics model updating
Ts = 0.2; %Sample time of a RL step
Vth = 50; %60 minimum expected speed of robot @ mm/s
States   = StateTable();  % the table of states
Actions  = ActionTable(); % the table of actions

nstates     = size(States,1);
nactions    = size(Actions,1);
Q           = QTable( nstates,nactions,0 );  % the Qtable
trace       = QTable( nstates,nactions,0 );  % the elegibility trace

alpha       = 0.1;   % learning rate
gamma       = 1;   % discount factor
epsilon0     = 0.2;  % probability of a random action selection
lambda      = 0.6;   % the decaying elegibiliy trace parameter
p0=1;

xpoints=[];
ypoints=[];

EXPLORATION_STEPS = maxepisodes/10;
epsDec = -log(0.05) * 1/EXPLORATION_STEPS;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios
epsilon = epsilon0;
p=p0;

for i=1:maxepisodes    
         
    [action,Vxr,Vyr,Vtheta,ro,fi,gama,Pt,Pb,Pr,Vb,dV,total_reward,steps,Q,trace,fitness_k,btd_k,Vavg(i),Vth,time,faults,xb,yb,yfi] = Episode( wf,maxDistance, Q, alpha, gamma, epsilon, p, States, Actions, Ts, Vth, ro_max, lambda, trace, NOISE);
    
    %disp(['Epsilon:',num2str(eps),'  Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
        
    epsilon = epsilon0 * exp(-i*epsDec);
    p = p0*exp(-i*epsDec/5);
        
     
     if DRAWS==1

        xpoints(i)=i-1;
        ypoints(i)=steps;
        reward(i,1)=total_reward/steps;
        fitness(i,1)=fitness_k;
        btd(i,1)=btd_k;
        tp_faults(i,1)=faults/steps*100;
             
        subplot(3,3,1);    
        plot(xpoints,reward,'b')      
        hold on
        plot(xpoints,btd,'r')      
        title([ 'Mean Reward(blue). Episode:',int2str(i) ])
        hold
        drawnow
        
        subplot(3,3,4)
        plot(xpoints,Vavg)
        title('Speed Average')
        drawnow
        
        subplot(3,3,7); 
        plot(xpoints,fitness)
        title('Fitness')
        drawnow
     
        subplot(3,3,2)
        plot(Pt(1,1),Pt(1,2),'*k')%posición del target 
        hold on
        plot(Pb(:,1),Pb(:,2),'*r')%posición de la bola
        plot(Pr(:,1),Pr(:,2),'g')% posición del robot
        axis([-100 maxDistance+100 -3000 3000])
        title('X-Y Plane');
        hold
        drawnow
        
        subplot(3,3,5);
        plot(time,ro,'g')
        hold on
        plot(time,Pr(:,1),'b')
        plot(time,Pb(:,1),'r*')
        plot(time,Pb(:,1)-Pr(:,1),'--k')
        title('Position and Pho')
        hold
        drawnow
        
        subplot(3,3,8);
        plot(time,Vb,'r')
        hold on
        plot(time,Vxr,'b')
        %plot(time,dV,'g')
        title('Delta Vbr')
        hold
        drawnow
             
        subplot(3,3,3),plot(time,ro)
        %axis([time(1) time(steps) 0 1000])
        title('pho(t)');
        
        subplot(3,3,6);
        plot(time,fi,'r')
        hold on
        plot(time,gama,'b')
        title('phi(t)(red) & gamma(t)(blue)');
        %axis([time(1) time(steps) -50 50])
        hold
        drawnow
        
        subplot(3,3,9);
        plot(time,xb,'b')
        hold on
        plot(time,yb,'r')
        plot(time,yfi,'k')
        title('xb(t)(blue) yb(t)(red) yfi(t)(black)');
        %axis([time(1) time(steps) -50 50])
        hold
        drawnow
        
     
     end


end



