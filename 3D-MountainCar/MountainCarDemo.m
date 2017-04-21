function [cR, itae, x_best, Qx, Qy, elapsedTime] =  MountainCarDemo( cfg, RL, run)
%MountainCarDemo, the main function of the demo
%maxepisodes: maximum number of episodes to run the demo

% Mountain Car Problem with SARSA 
% Programmed in Matlab 
% by:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
% 
% See Sutton & Barto book: Reinforcement Learning p.214

%set(gcf,'BackingStore','off')  % for realtime inverse kinematics
set(gcf,'name',['RL 3D-Mountain Car ' cfg.fileName])  % for realtime inverse kinematics
%set(gco,'Units','data')


maxepisodes = cfg.episodes;

[cfg.cores, cfg.nstates]   = BuildStateList(cfg);  % the list of states
cfg.actionlist  = BuildActionList(cfg); % the list of actions
cfg.nactions = size(cfg.actionlist,1);
RL.Q = BuildQTable( cfg.nstates, cfg.nactions, RL.q_init );  % the Qtable
RL.Qy = 0;
RL.Tx = 0;
RL.Ty = 0;
if cfg.DRL
    % the Qytable for Decentralized approach
    RL.Qy  = BuildQTable( cfg.nstates, cfg.nactions, RL.q_init );
    if cfg.MAapproach == 2
        RL.Tx = BuildQTable( cfg.nstates, cfg.nactions, 1 ); %temperature for lenient approach
        RL.Ty = BuildQTable( cfg.nstates, cfg.nactions, 1 ); %temperature for lenient approach
    end
end

epsilon0 = RL.param.epsilon;
softmaxT0 = RL.param.softmax;

EXPLORATION = maxepisodes/RL.param.exp_decay;
epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios


cfg.grafica     = false; % indicates if display the graphical interface
   
    xpoints=[];
    ypoints=[];
    itae=0;
    r_best=-inf;
    RL.stepsCum=0;
    RL.caFlag=[0];
    
for i=1:maxepisodes    

    [total_reward, steps, RL, x_, cfg] = Episode( cfg, RL );  
    RL.stepsCum = RL.stepsCum+steps;

    %keyboard  
    
    %disp(['Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(RL.param.epsilon)])
    
    if RL.param.exp_decay<1
        RL.param.epsilon = RL.param.epsilon * RL.param.exp_decay;
        RL.param.softmax = RL.param.softmax * RL.param.exp_decay;
        RL.param.p = RL.param.p * RL.param.p_decay;
    else
        RL.param.epsilon = epsilon0 * exp(-i*epsDec);
        RL.param.softmax = softmaxT0 * exp(-i*epsDec);
    end
    
    xpoints(i)=i;
    ypoints(i,:)=total_reward;
    dpa(i,:)=RL.param.dpaAvg/steps;
    %alpha(i,:)=RL.param.alpha*RL.param.caAvg/steps;
    alpha(i,:)=RL.param.caAvg/steps;
    TD(i,:)=RL.TDavg/steps;
           
    itae = itae + i*abs(mean(total_reward));
    
    if mean(total_reward)>r_best
        x_best=x_;
        r_best=mean(total_reward);
    end
    
    if cfg.DRAWS
        subplot(2,2,1)
        plot(xpoints,ypoints)
        if RL.param.softmax > 0
            title(['Run: ',int2str(run),'; Episode: ',int2str(i),'; temp: ', num2str(RL.param.softmax) ])    
        else
             title(['Run: ',int2str(run),'; Episode: ',int2str(i), '; eps: ', num2str(RL.param.epsilon) ])    
        end
         %axis([1  maxepisodes  cfg.maxsteps 0])
         
        subplot(2,2,2)
        plot(x_(:,1),x_(:,3),'ok')
        axis([1.1*cfg.feature_min(1) 1.1*cfg.feature_max(1) 1.1*cfg.feature_min(3) 1.1*cfg.feature_max(3)])
        title('Top view (x-y)')    
        
        subplot(2,2,3)
        %plot(TD)
        %hold on
        plot(alpha*RL.param.alpha)
        title('TD Avg and alphaAvg') 
        %axis([1  maxepisodes  -1 1])
        
        subplot(2,2,4)
        plot(RL.CA(:,1))
        %hold on
        %plot(RL.TD)
        title('CA-DPA and TD') 
        %axis([1  steps  -1 1])
        %hold off
        
        drawnow
    end
    
end

Qx = RL.Q;
if cfg.DRL
    Qy = RL.Qy;
else Qy=0;
end
itae = itae/maxepisodes;
cR = ypoints;
elapsedTime=cfg.timeCounter;
%mR = mean(mean(ypoints(ceil(maxepisodes*0.9):end)));

if ~cfg.opti
    disp(['RUN: ',int2str(run), '; MeanCumRew: ',num2str(mean(cR(ceil(maxepisodes*0.7):end))), ';  ITAE: ',num2str(itae), ';  eTime: ',num2str(elapsedTime)])
end