function  ScaraDemo( maxepisodes )
%MountainCarDemo, the main function of the demo
%maxepisodes: maximum number of episodes to run the demo
global TxtEpisode goal f1 f2 grafica

clc
statelist   = BuildStateList();  % the list of states
actionlist  = BuildActionList(); % the list of actions

nstates     = size(statelist,1);
nactions    = size(actionlist,1);

Q(1).QValues    = BuildQTable( nstates,nactions );  % the QTable
Q(2).QValues    = BuildQTable( nstates,nactions );  % the QTable
Q(3).QValues    = BuildQTable( nstates,nactions );  % the QTable
Q(4).QValues    = BuildQTable( nstates,nactions );  % the QTable


%temp =load('Q.mat');
%Q=temp.Q;
%alpha = 0.0;
%epsilon =0.0;

maxsteps    = 400;  % maximum number of steps per episode
alpha       = 0.3;  % learning rate
gamma       = 1.0;  % discount factor
epsilon     = 0.01; % probability of a random action selection
grafica     = false; % indicates if display the graphical interface


xpoints=[];
ypoints=[];

goal = [20 20 3];
%goal = randgoal();

goal_index=1;
for i=1:maxepisodes 
    

    goal = randgoal();  % activate the random location of the goal
    set(TxtEpisode,'string',strcat('Episode: ',int2str(i)));     
    [total_reward,steps,Q ] = Episode( maxsteps, Q, goal , alpha, gamma,epsilon,statelist,actionlist,grafica );    
    
    if (mod(i,20)==0)
        save Q.mat Q;
    end
    
    disp(['Espisode: ',int2str(i),' steps: ',int2str(steps),' reward: ',num2str(total_reward),' epsilon: ',num2str(epsilon)])
    
    xpoints(i) = i-1;
    ypoints(i) = steps;
    
    subplot(f2);
    plot(xpoints,ypoints);
    xlabel('Episodes');
    ylabel('Steps');    
    subplot(f1);
    %hold on
    %text(goal(1),goal(2),goal(3),int2str(i));
    hold off
    drawnow;
    epsilon = epsilon * 0.99;
    
    if (i>1000)
        grafica=true;
    end
    
    
end






