function  [reward, fitness, Vavg, tp_faults, Q] =Dribbling2d( nRun, DRAWS, maxepisodes, maxDistance, th_max, NOISE, Q_INIT, TRANSFER, EXPL_EPISODES_FACTOR)
%Dribbling1d SARSA, the main function of the trainning
%maxepisodes: maximum number of episodes to run the demo

%  SARSA 

load W-FLC;

%load Qnoise0;
%Qs=Qnoise0;
% load QPho;
% Qs=QPho;
load QokVx;
Qs=QokVx;

V_action_steps=[25, 25, 10];
Ts = 0.2; %Sample time of a RL step
States   = StateTable();  % the table of states
Actions  = ActionTable(V_action_steps); % the table of actions
nstates     = size(States,1);
nactions_x    = size(Actions(:,1),1);
nactions_y    = size(Actions(:,2),1);

Q           = QTable( nstates,nactions_x,Q_INIT );  % the Qtable for the vx agent
trace       = QTable( nstates,nactions_x,0 );  % the elegibility trace for the vx agent
Q_y           = QTable( nstates,nactions_y,Q_INIT );  % the Qtable for the vy agent
trace_y       = QTable( nstates,nactions_y,0 );  % the elegibility trace for the vy agent

%Qs=Q;

alpha       = 0.3;   % learning rate
gamma       = 1;   % discount factor
epsilon0     = 1;  % probability of a random action selection
lambda      = 0.9;   % the decaying elegibiliy trace parameter
p0=1;

EXPLORATION = maxepisodes/EXPL_EPISODES_FACTOR;
epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios
epsilon = epsilon0;
p=p0;

for i=1:maxepisodes    
            
    if TRANSFER>1, p=1; %acts greedy from source policy
    elseif TRANSFER==0, p=0; %learns from scratch
    end %else Transfer from source decaying as p
    
    [Vr,ro,fi,gama,Pt,Pb,Pr,Vb,total_reward,steps, Q,Q_y,trace,trace_y, fitness_k,btd_k,Vavg_k,time,faults] = Episode( wf,maxDistance, Q,Qs,Q_y, alpha, gamma, epsilon, p, States, Actions, Ts, th_max, lambda, trace, trace_y, NOISE, Q_INIT, V_action_steps);
    
    %disp(['Epsilon:',num2str(eps),'  Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
        
    epsilon = epsilon0 * exp(-i*epsDec);
    p = p0*exp(-i*epsDec*1);
        
     
     if DRAWS==1

        xpoints(i)=i-1;
        reward(i,1)=total_reward/steps;
        fitness(i,1)=fitness_k;
        Vavg(i,1)=Vavg_k;
        btd(i,1)=btd_k;
        tp_faults(i,1)=faults/steps*100;
             
        subplot(4,2,1);    
        plot(xpoints,reward,'b')      
        hold on
        plot(xpoints,btd,'r')      
        title([ 'Mean Reward(blue) Episode:',int2str(i), ' Run: ',int2str(nRun)])
        hold
                
        subplot(4,2,3)
        plot(xpoints,Vavg)
        title('Speed Average')
        %drawnow
        
        subplot(4,2,5); 
        plot(xpoints,fitness)
        title('Fitness')
        %drawnow
        
        subplot(4,2,7); 
        plot(xpoints,tp_faults)
        title('% Time Faults')
        %drawnow
     
        subplot(4,2,2)
        plot(Pt(1,1),Pt(1,2),'*k')%posición del target 
        hold on
        plot(Pb(:,1),Pb(:,2),'*r')%posición de la bola
        plot(Pr(:,1),Pr(:,2),'g')% posición del robot
        axis([-100 maxDistance+100 -3000 3000])
        title('X-Y Plane');
        hold
        %drawnow
        
%         subplot(4,2,6);
%         plot(time,ro,'g')
%         hold on
%         plot(time,Pr(:,1),'b')
%         plot(time,Pb(:,1),'r*')
%         plot(time,Pb(:,1)-Pr(:,1),'--k')
%         title('Position and Pho')
%         hold
%         drawnow
        
        subplot(4,2,4);
        plot(time,Vb,'r')
        hold on
        plot(time,Vr(:,1),'b')
        plot(time,Vr(:,2),'g')
        plot(time,Vr(:,3),'k')        
        title('Vb(red) Vr(bgk)')
        hold
        %drawnow
             
        subplot(4,2,6),plot(time,ro)
        %axis([time(1) time(steps) 0 1000])
        title('pho(t)');
        
        subplot(4,2,8);
        plot(time,fi,'r')
        hold on
        plot(time,gama,'b')
        title('phi(t)(red) & gamma(t)(blue)');
        %axis([time(1) time(steps) -50 50])
        hold
        %drawnow
        
%         subplot(4,2,9);
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



