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

RL.Q        = QTableRand( nstates,nactions, conf.Q_INIT );  % the Qtable for the vx agent
RL.Q_y      = QTableRand( nstates,nactions, conf.Q_INIT );  % the Qtable for the vy agent
RL.Q_rot    = QTableRand( nstates,nactions, conf.Q_INIT );  % the Qtable for the v_rot agent

RL.QM     = QTable( nstates,nactions, conf.boltzmann ); %temperature
RL.QM_y     = RL.QM;
RL.QM_rot     = RL.QM;

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

RL.param.alpha       = 2;   % temp. multiplication coeficient
RL.param.beta       = 2.5;  % exponent coeficient
RL.param.delta       = 0.995;  % temp. decay coeficient
RL.param.lambda      = 0.95;   % learning rate

RL.param.gamma       = 1;   % discount factor

epsilon0             = 1;  % probability of a random action selection
p0                   = 1;
temp0                =  conf.boltzmann;
alpha0              = 1;%RL.param.alpha;

if conf.TRANSFER<0 %Para pruebas de performance
    epsilon0             = 0;    
    p0                   = 0;
end    

EXPLORATION = conf.episodes/conf.EXPL_EPISODES_FACTOR;
epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios
epsInc2 = -log(0.10) * 1/EXPLORATION;  %epsilon decrece a un 10% (0.1) en maxEpisodes cuartos (maxepisodes/EXPL_EPISODES_FACTOR)
epsDec2 = -log(0.70) * 1/EXPLORATION;  %epsilon decrece a un 70% (0.7) en maxEpisodes cuartos (maxepisodes/EXPL_EPISODES_FACTOR)

RL.param.M = conf.Mtimes;
RL.param.epsilon = epsilon0;
RL.param.p = p0;
RL.param.boltzmann = temp0;
RL.param.alpha2 = alpha0; 

goals=0;
for i=1:conf.episodes    
    
    if i>conf.episodes/2
        i
    end
            
    if conf.TRANSFER>1, RL.param.p=1; %acts greedy from source policy
    elseif conf.TRANSFER == 0, RL.param.p=0; %learns from scratch
    end %else Transfer from source decaying as p
    
    [RL, Vr,ro,fi,gama,Pt,Pb,Pr,Vb,total_reward,steps,fitness_k,btd_k,Vavg_k,time,faults,goal_k] = Episode( wf, RL, States, Actions, conf);
    
    %disp(['Epsilon:',num2str(eps),'  Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
    
    dec = exp(-i*epsDec);
    dec2 = exp(-i*epsDec2);
    inc2 = 1-exp(-i*epsInc2);
    RL.param.epsilon = epsilon0*dec;
    RL.param.p = p0*dec;
    RL.param.boltzmann = temp0*dec;
    %RL.param.alpha2 = alpha0*inc2; 
    RL.param.alpha2 = alpha0*dec2; 
    %RL.param.alpha2 = alpha0*dec2*inc2; %trapmf(i,[1 300 600 1500]);
    
    xpoints(i)=i-1;
    reward(i,:)=total_reward/steps;
    e_time(i,1)=steps*Ts;
    Vavg(i,1)=Vavg_k/conf.Vr_max(1)*100;
    %btd(i,1)=btd_k;
    tp_faults(i,1)=faults/steps*100;
    goals=goal_k+goals;
    softmax(i,:)=RL.cum_fa/steps;
    
    if conf.DRAWS==1
        
        subplot(3,3,1)
        plot(xpoints,Vavg)
        title('% Max. Fw. Speed Avg.')
        %drawnow
        
        subplot(3,3,4); 
        plot(xpoints,tp_faults)
        title('% Time Faults')
        %drawnow
        
        subplot(3,3,7); 
        plot(xpoints, 0.5*(100-Vavg+tp_faults))
        title('Global Fitness')
        %drawnow
        
        
        subplot(3,3,2);    
        plot(xpoints,reward(:,1),'r')      
        hold on
        plot(xpoints,reward(:,2),'g')      
        plot(xpoints,reward(:,3),'b')      
        %plot(xpoints,btd,'k')      
        title([ 'Mean Reward(rgb) Episode:',int2str(i), ' p=',sprintf('%.2f',RL.param.p) ' Run: ',int2str(nRun)])
        hold
        
        subplot(3,3,5);    
        plot(xpoints,softmax(:,1),'r')      
        hold on
        plot(xpoints,softmax(:,2),'g')      
        plot(xpoints,softmax(:,3),'b')      
        title(['Mean Softmax_P(rgb) FA*alpha: ', sprintf('%.3f',RL.param.alpha2*RL.param.alpha)])
        hold
               
        
        FAalpha(i,1) = RL.param.alpha2*RL.param.alpha;
        
        subplot(3,3,8);    
        plot(xpoints,FAalpha,'k')      
        hold on
        %plot(xpoints,mean(softmax,2),'r')      
        %plot(xpoints,1-mean(softmax,2),'r')      
        plot(xpoints,(1-min(softmax,[],2))*RL.param.alpha,'g')      
        %plot(xpoints,1-max(softmax,[],2),'b')      
        title('FA*alpha(k); P-softmax: mean(r),min(g),max(b)')
        hold
           
        subplot(3,3,3)
        plot(Pt(1,1),Pt(1,2),'*k')%posición del target 
        hold on
        plot(Pb(:,1),Pb(:,2),'*r')%posición de la bola
        plot(Pr(:,1),Pr(:,2),'g')% posición del robot
        axis([-100 conf.maxDistance+100 -4000 4000])
        title('X-Y Plane');
        hold
        
       
        subplot(3,3,6);
        plot(time,Vr(:,1),'r')
        hold on
        plot(time,Vr(:,2),'g')
        plot(time,Vr(:,3),'b')        
        title('Vb(k) Vr(rgb)')
        hold
         
              
        subplot(3,3,9);
        plot(time,ro,'r')
        hold on
        plot(time,fi,'g')
        plot(time,gama,'b')
        title('pho(t)r; phi(t)g; gamma(t)b');
        %axis([time(1) time(steps) -50 50])
        hold

        drawnow
    
    end
     
     
     Qx=RL.Q;
     Qy=RL.Q_y;
     Qrot=RL.Q_rot;

end



