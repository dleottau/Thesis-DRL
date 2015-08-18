function [total_reward,steps,RL,x_] = Episode( cfg, RL)
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

e_trace     = BuildQTable( cfg.nstates, cfg.nactions, 0); %elegibility traces
if cfg.DRL
    e_trace_y     = BuildQTable( cfg.nstates, cfg.nactions, 0); %elegibility traces
end

steps        = 0;
total_reward = 0;

% convert the continous state variables to an index of the statelist
% selects an action using the epsilon greedy selection strategy
x = cfg.init_condition;

FV = getFeatureVector(x, cfg.cores, cfg.DRL);
if cfg.DRL
    [ax, px] = action_selection(RL.Q, FV(:,1), RL.param);
    [ay, py] = action_selection(RL.Qy, FV(:,2), RL.param);
else
    [a, p] = action_selection(RL.Q, FV, RL.param);
end

for i=1: cfg.maxsteps    
        
    % convert the index of the action into an action value
    if cfg.DRL    
        action = [cfg.actionlist(ax,:) cfg.actionlist(ay,:)];    
    else
        action = cfg.actionlist(a,:);    
    end
    
    
    %=======
%     if x(2)>=0
%         action(1)=1;
%     else action(1)=-1;
%     end
%     
%     if x(4)>=0
%         action(2)=1;
%     else action(2)=-1;
%     end
    %=======
    
    
    %do the selected action and get the next car state    
    xp  = DoAction( action, x, cfg);  
    % extrat feature vectore and select action prime
    FVp = getFeatureVector(xp, cfg.cores, cfg.DRL);
    if cfg.DRL
        [apx, px] = action_selection(RL.Q, FVp(:,1), RL.param);
        [apy, py] = action_selection(RL.Qy, FVp(:,2), RL.param);
    else
        [ap, p] = action_selection(RL.Q, FVp, RL.param);
    end


    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(xp, cfg.goalState, cfg.DRL);
    total_reward = total_reward + r;
    
    
    % Update the Qtable, that is,  learn from the experience
    if cfg.DRL    
        [ RL.Q, e_trace] = UpdateSARSA( FV(:,1), ax, r(1), FVp(:,1), apx, RL.Q, e_trace, RL.param);
        [ RL.Qy, e_trace_y] = UpdateSARSA( FV(:,2), ay, r(2), FVp(:,2), apy, RL.Qy, e_trace_y, RL.param);
        %update the current variables
        ax = apx;
        ay = apy;
    else
        [ RL.Q, e_trace] = UpdateSARSA( FV, a, r, FVp, ap, RL.Q, e_trace, RL.param);
        %update the current variables
        a = ap;
    end
    
    %update the current variables
    FV = FVp;
    x = xp;
    x_(i,:)=x;
    
    %increment the step counter.
    steps=steps+1;
    
      
    % if the car reachs the goal breaks the episode
    if (f==true)
        break
    end
    
end
%toc()/steps


