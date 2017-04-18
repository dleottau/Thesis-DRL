function [total_reward,steps,RL,x_,cfg] = Episode( cfg, RL)
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
RL.param.ca = 1/3;
RL.param.pa = 1/3;
RL.param.dpaAvg = 0;
RL.param.caAvg = 0;
RL.TDavg(1)=0;
RL.TDavg(2)=0;
%RL.param.dpa = 0;
TDx=0;
TDy=0;


% convert the continous state variables to an index of the statelist
% selects an action using the epsilon greedy selection strategy
x = cfg.init_condition;

FV = getFeatureVector(x, cfg.cores, cfg.DRL);
if cfg.DRL
    [ax, px] = action_selection(RL.Q, FV(:,1), RL.param, RL.Tx);
    [ay, py] = action_selection(RL.Qy, FV(:,2), RL.param, RL.Ty);
    ax = sourcePolicy(x(1:2),ax,cfg.transfer,RL.param);
    ay = sourcePolicy(x(3:4),ay,cfg.transfer,RL.param);
else
    [a, p] = action_selection(RL.Q, FV, RL.param, 0);
end

RL.CA=zeros(cfg.maxsteps,2);

for i = 1: cfg.maxsteps    
        
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
    tic;
    FVp = getFeatureVector(xp, cfg.cores, cfg.DRL);
    if cfg.DRL
        [apx, fa_x] = action_selection(RL.Q, FVp(:,1), RL.param, RL.Tx);
        [apy, fa_y] = action_selection(RL.Qy, FVp(:,2), RL.param, RL.Ty);
        apx = sourcePolicy(x(1:2),apx,cfg.transfer,RL.param);
        apy = sourcePolicy(x(3:4),apy,cfg.transfer,RL.param);
        
        % Frequency adjusted param
        pap = min([fa_x, fa_y])+1E-6;
        cap = pap;
        RL.param.dpa = pap-RL.param.pa; % gradient of prob. from boltzman
        %keyboard
        
        RL.param.caAvg = RL.param.ca + RL.param.caAvg;
        RL.param.dpaAvg = RL.param.dpa + RL.param.dpaAvg;
        if cfg.MAapproach==1;
            cap = 1-cap;
        elseif cfg.MAapproach==4
            dpa=min(TDx,TDy);%abs(RL.param.dpa);
            if      dpa<-1, cap = 1-cap;
            elseif  abs(dpa)<0.2, cap = 1-cap;
                %organizar dpa individuales, el minimo ca para el mejor dpa
            end
        end
    else
        [ap, pap] = action_selection(RL.Q, FVp, RL.param, 0);
        pap=1-pap;
    end
    
    % select MA approach
    if cfg.MAapproach==0 || cfg.MAapproach==2
        pap=1;
    end
    
    
    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(xp, cfg.goalState, cfg.DRL);
    total_reward = total_reward + r;
        
    % Update the Qtable, that is,  learn from the experience
    
    if cfg.DRL   
                                   
        [ RL.Q, e_trace, RL.Tx, TDx] = UpdateSARSA(FV(:,1), ax, r(1), FVp(:,1), apx, RL.Q, e_trace, RL.param,RL.Tx, cfg.MAapproach);
        [ RL.Qy, e_trace_y, RL.Ty, TDy] = UpdateSARSA(FV(:,2), ay, r(2), FVp(:,2), apy, RL.Qy, e_trace_y, RL.param,RL.Ty, cfg.MAapproach);
        %update the current variables
        ax = apx;
        ay = apy;
    else
        [ RL.Q, e_trace, RL.Tx, TDx] = UpdateSARSA( FV, a, r, FVp, ap, RL.Q, e_trace, RL.param, RL.Tx, cfg.MAapproach);
        TDy=0;
        %update the current variables
        a = ap;
    end
    cfg.timeCounter=cfg.timeCounter+toc;
        
    %update the current variables
    FV = FVp;
    x = xp;
    x_(i,:)=x;
    RL.param.ca = cap;
    RL.param.pa = pap;
    
    %increment the step counter.
    steps=steps+1;
    
    RL.CA(steps,1)=RL.param.ca; 
    RL.CA(steps,2)=RL.param.dpa;
    RL.TD(steps,1)=TDx;
    RL.TD(steps,2)=TDy;
    RL.TDavg(1)=RL.TDavg(1)+TDx;
    RL.TDavg(2)=RL.TDavg(2)+TDy;
    
     %keyboard
     
    % if the car reachs the goal breaks the episode
    if f==true
        break
    elseif RL.stepsCum>cfg.maxsteps*cfg.episodes/2.5
        % if definitivelly doesn't converge just finishing training to accelerate procedure
        steps = cfg.maxsteps;
        total_reward = -cfg.maxsteps;
        break
    end
    
    
   
   
end
%toc()/steps


