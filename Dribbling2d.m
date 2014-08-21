function  [reward, fitness, Vavg, tp_faults, Q] =Dribbling2d(  DRAWS, maxepisodes, maxDistance, th_max, NOISE)
%Dribbling1d SARSA, the main function of the trainning
%maxepisodes: maximum number of episodes to run the demo

%  SARSA 

%clc
%clf

load W-FLC;
%load ene11;

%dt = 0.2;  %sample time of the kinematics model updating
Ts = 0.2; %Sample time of a RL step
Vth = 65; %60 minimum expected speed of robot @ mm/s
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

EXPLORATION_STEPS = maxepisodes/10;
epsDec = -log(0.05) * 1/EXPLORATION_STEPS;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios
epsilon = epsilon0;
p=p0;

for i=1:maxepisodes    
         
    [Vxr,ro,fi,gama,Pt,Pb,Pr,Vb,total_reward,steps,Q,trace,fitness_k,btd_k,Vavg_k,Vth,time,faults] = Episode( wf,maxDistance, Q, alpha, gamma, epsilon, p, States, Actions, Ts, Vth, th_max, lambda, trace, NOISE);
    
    %disp(['Epsilon:',num2str(eps),'  Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
        
    epsilon = epsilon0 * exp(-i*epsDec);
    p = p0*exp(-i*epsDec/5);
        
     
     if DRAWS==1

        xpoints(i)=i-1;
        reward(i)=total_reward/steps;
        fitness(i)=fitness_k;
        Vavg(i)=Vavg_k;
        btd(i)=btd_k;
        tp_faults(i)=faults/steps*100;
             
        subplot(2,4,1);    
        plot(xpoints,reward,'b')      
        hold on
        plot(xpoints,btd,'r')      
        title([ 'Mean Reward(blue). Episode:',int2str(i) ])
        hold
        %drawnow
        
        subplot(2,4,2)
        plot(xpoints,Vavg)
        title('Speed Average')
        %drawnow
        
        subplot(2,4,3); 
        plot(xpoints,fitness)
        title('Fitness')
        %drawnow
        
        subplot(2,4,4); 
        plot(xpoints,tp_faults)
        title('% Time Faults')
        %drawnow
     
        subplot(2,4,5)
        plot(Pt(1,1),Pt(1,2),'*k')%posición del target 
        hold on
        plot(Pb(:,1),Pb(:,2),'*r')%posición de la bola
        plot(Pr(:,1),Pr(:,2),'g')% posición del robot
        axis([-100 maxDistance+100 -3000 3000])
        title('X-Y Plane');
        hold
        %drawnow
        
%         subplot(2,4,6);
%         plot(time,ro,'g')
%         hold on
%         plot(time,Pr(:,1),'b')
%         plot(time,Pb(:,1),'r*')
%         plot(time,Pb(:,1)-Pr(:,1),'--k')
%         title('Position and Pho')
%         hold
%         drawnow
        
        subplot(2,4,6);
        plot(time,Vb,'r')
        hold on
        plot(time,Vxr,'b')
        %plot(time,dV,'g')
        title('Delta Vbr')
        hold
        %drawnow
             
        subplot(2,4,7),plot(time,ro)
        %axis([time(1) time(steps) 0 1000])
        title('pho(t)');
        
        subplot(2,4,8);
        plot(time,fi,'r')
        hold on
        plot(time,gama,'b')
        title('phi(t)(red) & gamma(t)(blue)');
        %axis([time(1) time(steps) -50 50])
        hold
        %drawnow
        
%         subplot(2,4,9);
%         plot(time,xb,'b')
%         hold on
%         plot(time,yb,'r')
%         plot(time,yfi,'k')
%         title('xb(t)(blue) yb(t)(red) yfi(t)(black)');
%         %axis([time(1) time(steps) -50 50])
%         hold
%         drawnow

        drawnow
        
     
     end


end



