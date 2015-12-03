function  f=ScaraDemo( maxepisodes, param )
%MountainCarDemo, the main function of the demo
%maxepisodes: maximum number of episodes to run the demo
global TxtEpisode goal f1 f2 grafica

clc
statelist   = BuildStateList();  % the list of states
actionlist  = BuildActionList(); % the list of actions

nstates     = size(statelist,1);
nactions    = size(actionlist,1);

% Q(1).QValues    = BuildQTable( nstates,nactions,0 );  % the QTable
% Q(2).QValues    = BuildQTable( nstates,nactions,0 );  % the QTable
% Q(3).QValues    = BuildQTable( nstates,nactions,0 );  % the QTable
% Q(4).QValues    = BuildQTable( nstates,nactions,0 );  % the QTable

for j=1:4
    Q(j).QValues    = BuildQTable( nstates,nactions,0 );  % the QTable
    T{j}  = 0;
    if param.MAapproach == 2
        T{j} = BuildQTable(nstates, nactions, 1);
    end
end

%temp =load('Q.mat');
%Q=temp.Q;
%alpha = 0.0;
%epsilon =0.0;

%grafica     = false; % indicates if display the graphical interface


xpoints=[];
ypoints=[];

goal = [20 20 3];
%goal = randgoal();

goal_index=1;
for i=1:maxepisodes 
    
    goal = randgoal();  % activate the random location of the goal
    set(TxtEpisode,'string',strcat('Episode: ',int2str(i)));     
    [total_reward,steps,Q ] = Episode( Q, goal, statelist,actionlist,grafica, param, T );    
    
    if (mod(i,20)==0)
        save Q.mat Q;
    end
    
    %disp(['Espisode: ',int2str(i),' steps: ',int2str(steps),' reward: ',num2str(total_reward),' epsilon: ',num2str(param.epsilon)])
    
    xpoints(i) = i-1;
    ypoints(i) = steps;
    
    if param.DRAW
        subplot(f2);
        plot(xpoints,ypoints);
        xlabel('Episodes');
        ylabel('Steps');    
        subplot(f1);
        %hold on
        %text(goal(1),goal(2),goal(3),int2str(i));
        hold off
        drawnow;
    end

    param.epsilon = param.epsilon * 0.99;
    param.softmax = param.softmax * 0.99;
    
    if (i>1000)
        grafica=true;
    end
    
    
end

f=100*mean(ypoints(ceil(0.7*maxepisodes):end))/param.maxsteps;







