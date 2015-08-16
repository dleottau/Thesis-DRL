function [mR, f] =  MountainCarDemo( maxepisodes, param)
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

cfg.DRL = true;

cfg.maxsteps    = 5000;              % maximum number of steps per episode
cfg.feature_min = [-1.2 -0.07  -1.2 -0.07];
cfg.feature_max = [ 0.6  0.07   0.6  0.07];
cfg.init_condition = [-pi()/6   0.0 -pi()/6 0.0];
cfg.nCores = [9 6 9 6];
cfg.stdDiv = [.5 .5 .5 .5];
cfg.actionStep = [1 1];
cfg.goalState = [0.5 0.5];

cfg.q_init = 0;
cfg.graphic = false;

[cfg.cores, cfg.nstates]   = BuildStateList(cfg);  % the list of states
cfg.actionlist  = BuildActionList(cfg); % the list of actions

cfg.nactions = size(cfg.actionlist,1);
RL.Q = BuildQTable( cfg.nstates, cfg.nactions, cfg.q_init );  % the Qtable
if cfg.DRL
    % the Qytable for Decentralized approach
    RL.Qy = BuildQTable( cfg.nstates, cfg.nactions, cfg.q_init );
end

%param.alpha       = 0.1;   % learning rate
%param.gamma       = 0.99;   % discount factor
%param.lambda      = 0.95;
%param.epsilon     = 0.01;  % probability of a random action selection
%param.exp_decay   = 0.99; % factor to decay exploration rate

RL.param=param;

epsilon0 = RL.param.epsilon;
if RL.param.exp_decay>=1
    EXPLORATION = maxepisodes/RL.param.exp_decay;
    epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios
end

cfg.grafica     = false; % indicates if display the graphical interface
   
    xpoints=[];
    ypoints=[];
    itae=0;
    
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
    
    itae = itae + i*abs(total_reward);
    
    subplot(2,1,1)
    plot(xpoints,ypoints)      
    title(['Run: ',int2str(param.runs),'; epsilon: ',num2str(RL.param.epsilon),'; Episode: ',int2str(i) ])    
    
    subplot(2,1,2)
    plot(x_(:,1),x_(:,3),'>k')
    axis([1.1*cfg.feature_min(1) 1.1*cfg.feature_max(1) 1.1*cfg.feature_min(3) 1.1*cfg.feature_max(3)])
    title('Top view (x-y)')    
    
    drawnow

    if (i>00)
        %cfg.grafica=true;
    end
end

f = itae/maxepisodes;
mR = mean(ypoints(ceil(maxepisodes*0.9):end));
