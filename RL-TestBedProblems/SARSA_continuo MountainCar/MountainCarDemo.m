function [cR, f, x_best, Qx, Qy] =  MountainCarDemo( cfg, RL)
%MountainCarDemo, the main function of the demo
%maxepisodes: maximum number of episodes to run the demo

% Mountain Car Problem with SARSA 
% Programmed in Matlab 
% by:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
% 
% See Sutton & Barto book: Reinforcement Learning p.214

set(gcf,'BackingStore','off')  % for realtime inverse kinematics
set(gcf,'name','Reinforcement Learning Mountain Car')  % for realtime inverse kinematics
set(gco,'Units','data')


maxepisodes = cfg.episodes;

[cfg.cores, cfg.nstates]   = BuildStateList(cfg);  % the list of states
cfg.actionlist  = BuildActionList(cfg); % the list of actions

cfg.nactions = size(cfg.actionlist,1);
RL.Q = BuildQTable( cfg.nstates, cfg.nactions, RL.q_init );  % the Qtable
if cfg.DRL
    % the Qytable for Decentralized approach
    RL.Qy = BuildQTable( cfg.nstates, cfg.nactions, RL.q_init );
end

%RL.param.alpha       = 0.1;   % learning rate
%RL.param.gamma       = 0.99;   % discount factor
%RL.param.lambda      = 0.95;
%RL.param.epsilon     = 0.01;  % probability of a random action selection
%RL.param.exp_decay   = 0.99; % factor to decay exploration rate



epsilon0 = RL.param.epsilon;
if RL.param.exp_decay>=1
    EXPLORATION = maxepisodes/RL.param.exp_decay;
    epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios
end

cfg.grafica     = false; % indicates if display the graphical interface
   
    xpoints=[];
    ypoints=[];
    itae=0;
    r_best=-inf;
    
for i=1:maxepisodes    

    [total_reward, steps, RL, x_] = Episode( cfg, RL );    

    %disp(['Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(RL.param.epsilon)])
    
    if RL.param.exp_decay<1
        RL.param.epsilon = RL.param.epsilon * RL.param.exp_decay;
    else
        RL.param.epsilon = epsilon0 * exp(-i*epsDec);
    end
    
    xpoints(i)=i;
    ypoints(i,:)=total_reward;
       
    itae = itae + i*abs(mean(total_reward));
    
    if mean(total_reward)>r_best
        x_best=x_;
        r_best=mean(total_reward);
    end
    subplot(2,1,1)
    plot(xpoints,ypoints)      
    title(['Run: ',int2str(cfg.runs),'; epsilon: ',num2str(RL.param.epsilon),'; Episode: ',int2str(i) ])    
    
    subplot(2,1,2)
    plot(x_(:,1),x_(:,3),'ok')
    axis([1.1*cfg.feature_min(1) 1.1*cfg.feature_max(1) 1.1*cfg.feature_min(3) 1.1*cfg.feature_max(3)])
    title('Top view (x-y)')    
    
    drawnow

    
end

Qx = RL.Q;
if cfg.DRL
    Qy = RL.Qy;
else Qy=0;
end
f = itae/maxepisodes;
cR = ypoints;
%mR = mean(mean(ypoints(ceil(maxepisodes*0.9):end)));
