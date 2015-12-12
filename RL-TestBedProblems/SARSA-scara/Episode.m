function [ total_reward,steps,Q,grafica ] = Episode( Q ,goal,statelist,actionlist,grafic, param, T, grafica )
%MountainCarEpisode do one episode of the mountain car
% maxstepts: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions


%global grafica
persistent traza xt robot_state
% initial state
if (isempty( xt)|| true )
    [xt robot_state] = DoAction([0 0 0 2],[0 0 0 0]);
end
steps = 0;
total_reward = 0;

maxsteps=param.maxsteps;

xf = goal(1);
yf = goal(2);
zf = goal(3);

% initial perception
s  = [];
sp = [];
a  = [];
ap = [];
p  = [];
param.p  = [0 0 0]; 
param.pcoop=1;

for i=1:4
    % convert the continous state variables to an index of the statelist
    s(i)   = DiscretizeState([(xf-xt(1)) (yf-xt(2)) (zf-xt(3))],statelist);
    % selects an action using the epsilon greedy selection strategy
    [a(i), p(i)]   = action_selection(Q(i).QValues,s(i),param,T{i});
    %a(i)   = e_greedy_selection(Q(i).QValues,s(i),param.epsilon);
end


for i=1:maxsteps    
    
    % convert the index of the action into an action value for every robot
    for i=1:4
        action(i) = actionlist(a(i));    
    end
       
    [xt robot_state] = DoAction(robot_state , action);
   
    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(robot_state,xt,goal,steps);
    total_reward = total_reward + r;
       
    for i=1:4
        % convert the continous state variables to an index of the statelist
        sp(i) = DiscretizeState([(xf-xt(1)) (yf-xt(2)) (zf-xt(3))],statelist);
       
        % selects an action using the epsilon greedy selection strategy
        [ap(i), p(i)]   = action_selection(Q(i).QValues,sp(i),param,T{i});
        %ap(i) = e_greedy_selection(Q(i).QValues,sp(i),param.epsilon);
               
        % Update the Qtable, that is,  learn from the experience    
        [Q(i).QValues, T{i}] = UpdateSARSA( s(i), a(i), r, sp(i), ap(i), Q(i).QValues, param, T{i} );
    end
    
    % update adaptive learning rate
    param.pcoop = 1;
    % if MA approach is cooperative adaptive learning rate
    if param.MAapproach==1
        bias=1/length(actionlist);
        param.pcoop = 1-min(param.p-bias); % decremental Learnng Rate
        %param.pcoop = min(param.p-bias); % incremental Learnng Rate
        param.pcoop = clipDLF(param.pcoop, 0, 1);
    end
    param.p = p;
    
    %update the current state
    s = sp;
    %update the current action
    a = ap;
        
    grafic = grafica;  
    tam = size(traza);
    tam=tam(1);
    traza(tam+1,1)=xt(1);
    traza(tam+1,2)=xt(2);
    traza(tam+1,3)=xt(3); 
    if (grafica==true) 
        scaraplot(robot_state(1),robot_state(2),robot_state(3),robot_state(4),goal,traza);
        title(['Steps: ',int2str(steps)]);
        drawnow;
    end
    
    %increment the step counter.
    steps=steps+1;
    
    % if the car reachs the goal breaks the episode
    if (f==true)
        break
    end
    
end
if param.DRAW
    scaraplot(robot_state(1),robot_state(2),robot_state(3),robot_state(4),goal,traza);
    title(['Steps: ',int2str(steps)]);
    drawnow;
end

