function [total_reward,steps,RL] = Episode( cfg, RL)
%maxsteps, Q , alpha, gamma,lambda,epsilon,statelist,dev,actionlist,grafic )

%MountainCarEpisode do one episode of the mountain car with sarsa learning
% maxstepts: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

% Mountain Car Problem with SARSA 
% Programmed in Matlab 
% by:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
% 
% See Sutton & Barto book: Reinforcement Learning p.214


%nstates     = size(statelist,1);
%nactions    = size(actionlist,1);
e_trace     = BuildQTable( cfg.nstates, cfg.nactions ); %elegibility traces
initial_position = -0.5;
initial_speed    =  0.0;

x            = [initial_position,initial_speed];
steps        = 0;
total_reward = 0;

% convert the continous state variables to an index of the statelist
%s   = DiscretizeState(x,statelist);
% selects an action using the epsilon greedy selection strategy
FV = getFeatureVector(x, cfg.cores);
a   = e_greedy_selection(RL.Q, FV, RL.param.epsilon);
%transfering knoweledge
a = sourcePolicy(x,a,cfg.transfer,RL.param);

%tic();
for i=1: cfg.maxsteps    
       
    % convert the index of the action into an action value
    action = cfg.actionlist(a);    
    
    %do the selected action and get the next car state    
    xp  = DoAction( action , x );    
    FVp = getFeatureVector(xp, cfg.cores);
    
    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(xp);
    total_reward = total_reward + r;
    
    % select action prime
    ap = e_greedy_selection(RL.Q, FVp, RL.param.epsilon);
    
    %transfering knoweledge
    ap = sourcePolicy(x,ap,cfg.transfer,RL.param);
    
    % Update the Qtable, that is,  learn from the experience
    [ RL.Q, e_trace] = UpdateSARSA( FV, a, r, FVp, ap, RL.Q, e_trace, RL.param);
        
    %update the current variables
    a = ap;
    x = xp;
    FV = FVp;
        
    %increment the step counter.
    steps=steps+1;
    
    % Plot of the mountain car problem
    if (cfg.grafica==true)        
       %MountainCarPlot(x,action,steps);    
    end
    
    % if the car reachs the goal breaks the episode
    if (f==true)
        break
    end
    
end
%toc()/steps


