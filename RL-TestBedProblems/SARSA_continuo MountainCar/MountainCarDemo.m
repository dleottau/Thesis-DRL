function f =  MountainCarDemo( maxepisodes, params )
%MountainCarDemo, the main function of the demo
%maxepisodes: maximum number of episodes to run the demo

% Mountain Car Problem with SARSA 
% Programmed in Matlab 
% by:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
% 
% See Sutton & Barto book: Reinforcement Learning p.214



%clc
%clf
set(gcf,'BackingStore','off')  % for realtime inverse kinematics
set(gcf,'name','Reinforcement Learning Mountain Car')  % for realtime inverse kinematics
set(gco,'Units','data')


cfg.maxsteps    = 500;              % maximum number of steps per episode
[cfg.cores, cfg.nstates]   = BuildStateList();  % the list of states
cfg.actionlist  = BuildActionList(); % the list of actions

cfg.nactions    = size(cfg.actionlist,1);
RL.Q           = BuildQTable( cfg.nstates, cfg.nactions );  % the Qtable

%RL.param.alpha       = 0.1;   % learning rate
% RL.param.gamma       = 0.99;   % discount factor
% RL.param.lambda      = 0.95;
% RL.param.epsilon     = 0.01;  % probability of a random action selection
% RL.param.exp_decay   = 0.99; % factor to decay exploration rate

RL.param.alpha       = params.alpha;   % learning rate 
RL.param.gamma       = params.gamma;   % discount factor
RL.param.lambda      = params.lambda;
RL.param.epsilon     = params.epsilon;  % probability of a random action selection
RL.param.exp_decay   = params.exp_decay; % factor to decay exploration rate

epsilon0 = RL.param.epsilon;
EXPLORATION = maxepisodes/RL.param.exp_decay;
epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios

cfg.grafica     = false; % indicates if display the graphical interface
   
    xpoints=[];
    ypoints=[];
    itae=0;
    
for i=1:maxepisodes    

    [total_reward, steps, RL ] = Episode( cfg, RL );    

    %disp(['Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(RL.param.epsilon)])

    %RL.param.epsilon = RL.param.epsilon * RL.param.exp_decay;
    RL.param.epsilon = epsilon0 * exp(-i*epsDec);

    xpoints(i)=i;
    ypoints(i)=total_reward;
    
    itae = itae + i*abs(total_reward);
    
    %subplot(2,1,1);    
    plot(xpoints,ypoints)      
    title(['Run: ',int2str(params.runs),'; epsilon: ',num2str(RL.param.epsilon),'; Episode: ',int2str(i) ])    
    drawnow

    if (i>00)
        %cfg.grafica=true;
    end
end

%f = abs(mean(ypoints(round(maxepisodes*0.8):end)));
f = itae/maxepisodes;

