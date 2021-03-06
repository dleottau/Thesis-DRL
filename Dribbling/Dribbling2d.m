function  [reward, e_time, Vavg, tp_faults, Qx,Qy,Qrot] =Dribbling2d( conf, RL, run)
%Dribbling1d SARSA, the main function of the trainning


set(gcf,'name',['DRL Dribbling ' conf.fileName])  % for realtime inverse kinematics

Ts = conf.Ts; %Sample time of a RL step
[conf.States, conf.cores, conf.div_disc]   = StateTable( conf.feature_min, conf.feature_step, conf.feature_max );  % the table of states
conf.Actions  = ActionTable( conf.Vr_min, conf.V_action_steps, conf.Vr_max, conf.Voffset ); % the table of actions
conf.nstates     = size(conf.States,1);
conf.nactions    = size(conf.Actions,1);

if conf.TRANSFER>=0
RL.Q        = QTable( conf.nstates,conf.nactions, conf.Q_INIT );  % the Qtable for the vx agent
RL.Q_y      = RL.Q;  % the Qtable for the vy agent
RL.Q_rot    = RL.Q;  % the Qtable for the v_rot agent

RL.trace    = QTable( conf.nstates,conf.nactions,0 );  % the elegibility trace for the vx agent
RL.trace_y  = RL.trace;  % the elegibility trace for the vy agent
RL.trace_rot = RL.trace;  % the elegibility trace for the v_rot agent
end

RL.QM       = QTable( 1,1, 0 ); %QTable( conf.nstates,conf.nactions, 0 );
RL.QM_y     = RL.QM;
RL.QM_rot   = RL.QM;

RL.T        = 0;
RL.T_y      = 0;
RL.T_rot    = 0;
if conf.MAapproach == 2
    RL.T        = QTable( conf.nstates,conf.nactions, 1);
    RL.T_y      = RL.T;
    RL.T_rot    = RL.T;
end

%epsilon0             = 1;  % probability of a random action selection
%p0                   = 1;
epsilon0 = RL.param.epsilon;
p0       = 1;
temp0    =  RL.param.softmax;
alpha0   = 1;%RL.param.alpha;

if conf.TRANSFER<0 %Para pruebas de performance
    epsilon0             = 0;    
    p0                   = 0;
    temp0                = 0;
end    

EXPLORATION = conf.episodes/RL.param.exp_decay;
epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios
epsInc2 = -log(0.10) * 1/EXPLORATION;  %epsilon decrece a un 10% (0.1) en maxEpisodes cuartos (maxepisodes/EXPL_EPISODES_FACTOR)
epsDec2 = -log(0.70) * 1/EXPLORATION;  %epsilon decrece a un 70% (0.7) en maxEpisodes cuartos (maxepisodes/EXPL_EPISODES_FACTOR)

RL.param.M = conf.Mtimes;
RL.param.epsilon = epsilon0;
RL.param.p = p0;
RL.param.alpha2 = alpha0; 

RL.param.Beta=[1 1 1];

goals=0;
for i=1:conf.episodes    
            
    if conf.TRANSFER>1, 
        RL.param.p=1; %acts greedy from source policy
    elseif conf.TRANSFER == 0, 
        RL.param.p=0; %learns from scratch
    end %else Transfer from source decaying as p
    
    [RL, Vr,ro,fi,gama,Pt,Pb,Pr,Vb,total_reward,steps,fitness_k,btd_k,Vavg_k,time,faults,goal_k] = Episode(RL, conf);
    
    %disp(['Epsilon:',num2str(eps),'  Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
    
    xpoints(i)=i-1;
    reward(i,:)=total_reward/steps;
    e_time(i,1)=steps*Ts;
    Vavg(i,1)=Vavg_k/conf.Vr_max(1)*100;
    %btd(i,1)=btd_k;
    tp_faults(i,1)=faults/steps*100;
    goals=goal_k+goals;
       
    fitness=0.5*(100-Vavg+tp_faults);
        
    dec = exp(-i*epsDec);
    dec = dec*(1+cos(2*pi*RL.sinFreq/conf.episodes*i))/2;
    
    
    RL.param.epsilon = epsilon0*dec;
    RL.param.softmax = temp0*dec;
    
    % testing beta adaptive
    RL.param.p = p0*dec;
    %RL.param.p = 1*(1-min(Pa(i,:)));
    
    %RL.param.Pa = (RL.param.Pa).*(1-RL.cum_Pa/steps);
    RL.param.Beta = RL.param.Beta.*(1-RL.cum_Pa/steps);
    
    %mm=max(RL.param.Beta);
    %RL.param.Beta = [mm mm mm];
    
    Beta(i,:) = RL.param.Beta; 
    dPa(i,:) = RL.cum_dPa/steps;
    beta(i,:) = RL.param.p;
    
    % ----
        
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
        plot(xpoints, fitness)
        %plot(smooth(fitness, 0.07,'rloess'));
        title('Global Fitness')
        %drawnow
        
        
        subplot(3,3,2);    
        plot(xpoints,reward(:,1),'r')      
        hold on
        plot(xpoints,reward(:,2),'g')      
        plot(xpoints,reward(:,3),'b')      
        %plot(xpoints,btd,'k')
        if RL.param.softmax
            title([ 'Mean Reward(rgb) Episode:',int2str(i), ' z=',sprintf('%.2f',RL.param.softmax) ' Run: ',int2str(run)])
        else
            title([ 'Mean Reward(rgb) Episode:',int2str(i), ' p=',sprintf('%.2f',RL.param.p) ' Run: ',int2str(run)])
        end
        hold
        
        subplot(3,3,5);    
        plot(xpoints,dPa(:,1),'r')      
        hold on
        plot(xpoints,dPa(:,2),'g')      
        plot(xpoints,dPa(:,3),'b')      
        title(['dPa(rgb)'])
        hold

        subplot(3,3,8);    
        plot(xpoints,Beta(:,1),'r')      
        hold on
        plot(xpoints,Beta(:,2),'g')      
        plot(xpoints,Beta(:,3),'b')  
        %plot(xpoints,1-min(Pa,[],2),'k','LineWidth',2) 
        plot(xpoints,beta,'c','LineWidth',2)
        
        title(['Beta(rgb) beta(c)'])
        hold
               
              
%         subplot(3,3,8);    
%         plot(xpoints,min(Pa,[],2),'k')      
%         hold on
%         %plot(xpoints,mean(softmax,2),'r')      
%         %plot(xpoints,1-mean(softmax,2),'r')      
%         plot(xpoints,min(dPa,[],2),'g')      
%         %plot(xpoints,1-max(softmax,[],2),'b')      
%         title('FA*alpha(k); P-softmax: mean(r),min(g),max(b)')
%         hold
           
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

if ~conf.opti
    disp(['RUN: ',int2str(run), '; Fitness: ', num2str(mean(fitness(ceil(conf.episodes*conf.interval):end)))])
end



