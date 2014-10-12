function  [reward, e_time, Vavg, tp_faults, Qx,Qy,Qrot] =Dribbling2d( nRun, conf)
%Dribbling1d SARSA, the main function of the trainning


%  SARSA 

load W-FLC-RC2014;
%load Qx_RLFLC;
%load Qx_eRLFLC;
%load Qx_TDRL;
%load Qy_TDRL;
%load Qrot_TDRL;

Ts = conf.Ts; %Sample time of a RL step
[States, conf.cores, conf.div_disc]   = StateTable( conf.feature_min, conf.feature_step, conf.feature_max );  % the table of states
Actions  = ActionTable( conf.Vr_min, conf.V_action_steps, conf.Vr_max, conf.Voffset ); % the table of actions
nstates     = size(States,1);
nactions    = size(Actions,1);

%RL.Q         = Qx_eRLFLC;
%RL.Q        = Qx_RLFLC;
%RL.Q        = Qx_TDRL;
%RL.Q_y      = Qy_TDRL;
%RL.Q_rot    = Qrot_TDRL;

%RL.Qs       = Qx_eRLFLC;
RL.Q        = QTable( nstates,nactions, conf.Q_INIT );  % the Qtable for the vx agent
RL.Q_y      = RL.Q;  % the Qtable for the vy agent
RL.Q_rot    = RL.Q;  % the Qtable for the v_rot agent

RL.trace    = QTable( nstates,nactions,0 );  % the elegibility trace for the vx agent
RL.trace_y  = RL.trace;  % the elegibility trace for the vy agent
RL.trace_rot = RL.trace;  % the elegibility trace for the v_rot agent

RL.param.alpha       = 0.5;   % learning rate
RL.param.gamma       = 1;   % discount factor
RL.param.lambda      = 0.9;   % the decaying elegibiliy trace parameter
epsilon0             = 1;  % probability of a random action selection
p0                   = 1;

EXPLORATION = conf.episodes/conf.EXPL_EPISODES_FACTOR;
epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios

RL.param.epsilon = epsilon0;
RL.param.p=p0;

for i=1:conf.episodes    
            
    if conf.TRANSFER>1, RL.param.p=1; %acts greedy from source policy
    elseif conf.TRANSFER == 0, RL.param.p=0; %learns from scratch
    end %else Transfer from source decaying as p
    
    [RL, Vr,ro,fi,gama,Pt,Pb,Pr,Vb,total_reward,steps,fitness_k,btd_k,Vavg_k,time,faults] = Episode( wf, RL, States, Actions, conf);
    
    %disp(['Epsilon:',num2str(eps),'  Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
        
    RL.param.epsilon = epsilon0 * exp(-i*epsDec);
    RL.param.p = p0*exp(-i*epsDec*1);
        
     
     if conf.DRAWS==1

        xpoints(i)=i-1;
        reward(i,:)=total_reward/steps;
        e_time(i,1)=steps*Ts;
        Vavg(i,1)=Vavg_k;
        btd(i,1)=btd_k;
        tp_faults(i,1)=faults/steps*100;
             
        subplot(4,2,1);    
        plot(xpoints,reward(:,1),'r')      
        hold on
        plot(xpoints,reward(:,2),'g')      
        plot(xpoints,reward(:,3),'b')      
        %plot(xpoints,btd,'k')      
        title([ 'Mean Reward(rgb) Episode:',int2str(i), ' p=',sprintf('%.2f',RL.param.p) ' Run: ',int2str(nRun)])
        hold
                
        subplot(4,2,3)
        plot(xpoints,Vavg)
        title('Speed Average')
        %drawnow
        
        subplot(4,2,5); 
        plot(xpoints,e_time)
        title('Episode Time')
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
        axis([-100 conf.maxDistance+100 -4000 4000])
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
        %plot(time,Vb,'k')
        
        plot(time,Vr(:,1),'r')
        hold on
        plot(time,Vr(:,2),'g')
        plot(time,Vr(:,3),'b')        
        title('Vb(k) Vr(rgb)')
        hold
        %drawnow
             
        subplot(4,2,6),plot(time,ro)
        %axis([time(1) time(steps) 0 1000])
        title('pho(t)');
        
        subplot(4,2,8);
        plot(time,fi,'r')
        hold on
        plot(time,gama,'b')
        title('phi(t)(r) & gamma(t)(b)');
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
     
     Qx=RL.Q;
     Qy=RL.Q_y;
     Qrot=RL.Q_rot;

end



