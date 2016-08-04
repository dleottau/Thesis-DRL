function f =  MountainCarDemo( maxepisodes, x, run )

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


cfg.grafica     = 1; % indicates if display the graphical interface

cfg.feature_min = [-1.2 -0.07];
cfg.feature_max = [ 0.6  0.07];
cfg.init_condition = [-pi()/6   0.0];
cfg.nCores = [x(4) x(5)];%[9 6];
cfg.stdDiv = [0.5 0.5];%[.5 .5];
cfg.maxsteps= 500;              % maximum number of steps per episode

[cfg.cores, cfg.nstates]   = BuildStateList(cfg);  % the list of states
cfg.actionlist  = BuildActionList(); % the list of actions

cfg.nactions    = size(cfg.actionlist,1);
RL.Q           = BuildQTable( cfg.nstates, cfg.nactions );  % the Qtable

RL.param.alpha       = x(1);%0.1;   % learning rate
RL.param.gamma       = 0.99;   % discount factor
RL.param.lambda      = x(2);%0.8;
RL.param.epsilon     = x(3);%0.01;  % probability of a random action selection
RL.param.exp_decay   = 0.99; % factor to decay exploration rate
RL.param.p=1; % Transfer knowledge probability
RL.param.p_decay   = 0.95; % factor to decay transfer knowledge probability

epsilon0 = RL.param.epsilon;
EXPLORATION = maxepisodes/RL.param.exp_decay;
epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios

   
    xpoints=[];
    ypoints=[];
    itae=0;
    
for i=1:maxepisodes    

    [total_reward, steps, RL ] = Episode( cfg, RL );    

    %disp(['Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(RL.param.epsilon)])

    RL.param.epsilon = RL.param.epsilon * RL.param.exp_decay;
    %RL.param.epsilon = epsilon0 * exp(-i*epsDec);
    RL.param.p = RL.param.p * RL.param.p_decay;

    xpoints(i)=i;
    ypoints(i)=total_reward;
    
    itae = itae + i*abs(total_reward);
    
    if cfg.grafica
        %subplot(2,1,1);    
        plot(xpoints,ypoints)      
        title(['Run: ',int2str(run),'; p: ',num2str(RL.param.p),'; Episode: ',int2str(i) ])    
        drawnow
    end

    if (i>00)
        %cfg.grafica=true;
    end
end

f = abs(mean(ypoints(round(maxepisodes*0.5):end)));
%f = itae/maxepisodes;

