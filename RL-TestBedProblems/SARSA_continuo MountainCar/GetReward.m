function [ r,f ] = GetReward( x, goalState )
% MountainCarGetReward returns the reward at the current state
% x: a vector of position and velocity of the car
% r: the returned reward.
% f: true if the car reached the goal, otherwise f is false
    
position = x(1);
% bound for position; the goal is to reach position = 0.5
bpright=goalState(1);

r = -1;
f = false;
% 0 in case of success, -1 for all other moves
if( position >= bpright) 
	r = 0;
    f = true;
end

   


    
   


    
