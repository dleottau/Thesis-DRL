function  [reward, e_time, Vavg, tp_faults, goals, Qx,Qy,Qrot] =Dribbling2d( nRun, conf)
%Dribbling1d SARSA, the main function of the trainning

load W-FLC-RC2014;

if conf.TRANSFER<0 %Para pruebas de performance
    %load RC-2015/results/resultsFull_RL-FLC;
    %load RC-2015/results/resultsFull_eRL-FLC;
    load RC-2015/results/resultsFull_NASh;
    %load RC-2015/results/resultsFull_DRL;
    %load RC-2015/results/resultsFull_DRL-v2-20runs-Noise07-exp7;
    load RC-2015/results/resultsFull_NASh-v2-20runs-Noise01-exp8;
end

Ts = conf.Ts; %Sample time of a RL step
[States, conf.cores, conf.div_disc]   = StateTable( conf.feature_min, conf.feature_step, conf.feature_max );  % the table of states
Actions  = ActionTable( conf.Vr_min, conf.V_action_steps, conf.Vr_max, conf.Voffset ); % the table of actions
nstates     = size(States,1);
nactions    = size(Actions,1);

RL.Q        = QTable( nstates,nactions, conf.Q_INIT );  % the Qtable for the vx agent
RL.Q_y      = RL.Q;  % the Qtable for the vy agent
RL.Q_rot    = RL.Q;  % the Qtable for the v_rot agent

%Secuential learning
%load RC-2015/Qok_x1;
%load RC-2015/Qok_y2;
%load RC-2015/Qok_rot3;
%RL.Q        = Qok_x1;
%RL.Q_y      = Qok_y2;
%RL.Q_rot    = Qok_rot3;



%========TRANSFER=========
if conf.TRANSFER<0 %Para pruebas de performance
%RL.Qs       = Qx_eRLFLC;
%RL.Q         = Qx_eRLFLC;
%RL.Q        = Qx_RLFLC;
%load Qx_RLFLC;
%load Qx_eRLFLC;
%load Qx_DRL;
%load Qy_DRL;
%load Qrot_DRL;
RL.Q        = results.Qok_x;%Qx_DRL;
RL.Q_y      = results.Qok_y;%Qy_DRL;
RL.Q_rot    = results.Qok_rot;%Qrot_DRL;
clear results;
end
%========================




RL.trace    = QTable( nstates,nactions,0 );  % the elegibility trace for the vx agent
RL.trace_y  = RL.trace;  % the elegibility trace for the vy agent
RL.trace_rot = RL.trace;  % the elegibility trace for the v_rot agent

RL.param.alpha       = 0.5;   % 0.3-0.5 learning rate
RL.param.gamma       = 1;   % discount factor
RL.param.lambda      = 0.9;   % the decaying elegibiliy trace parameter
epsilon0             = 1;  % probability of a random action selection
p0                   = 1;
temp0                =  conf.boltzmann;

if conf.TRANSFER<0 %Para pruebas de performance
    epsilon0             = 0;    
    p0                   = 0;
end    

EXPLORATION = conf.episodes/conf.EXPL_EPISODES_FACTOR;
epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios
epsDec2 = -log(0.10) * 1/EXPLORATION;  %epsilon decrece a un 50% (0.5) en maxEpisodes cuartos (maxepisodes/EXPL_EPISODES_FACTOR)

RL.param.epsilon = epsilon0;
RL.param.p = p0;
RL.param.boltzmann = temp0;
RL.param.alpha2 = RL.param.alpha; 

goals=0;
for i=1:conf.episodes    
            
    if conf.TRANSFER>1, RL.param.p=1; %acts greedy from source policy
    elseif conf.TRANSFER == 0, RL.param.p=0; %learns from scratch
    end %else Transfer from source decaying as p
    
    [RL, Vr,ro,fi,gama,Pt,Pb,Pr,Vb,total_reward,steps,fitness_k,btd_k,Vavg_k,time,faults,goal_k] = Episode( wf, RL, States, Actions, conf);
    
    %disp(['Epsilon:',num2str(eps),'  Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
    
    dec = exp(-i*epsDec);
    dec2 = exp(-i*epsDec2);
    RL.param.epsilon = epsilon0*dec;
    RL.param.p = p0*dec;
    RL.param.boltzmann = temp0*dec;
    RL.param.alpha2 = RL.param.alpha*(1-dec2); 
    
    xpoints(i)=i-1;
    reward(i,:)=total_reward/steps;
    e_time(i,1)=steps*Ts;
    Vavg(i,1)=Vavg_k/conf.Vr_max(1)*100;
    %btd(i,1)=btd_k;
    tp_faults(i,1)=faults/steps*100;
    goals=goal_k+goals;
    
    if conf.DRAWS==1
        
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
        title('% Max. Fw. Speed Avg.')
        %drawnow
        
        subplot(4,2,5); 
        plot(xpoints,tp_faults)
        title('% Time Faults')
        %drawnow
        
        subplot(4,2,7); 
        plot(xpoints, 0.5*(100-Vavg+tp_faults))
        title('Global Fitness')
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



