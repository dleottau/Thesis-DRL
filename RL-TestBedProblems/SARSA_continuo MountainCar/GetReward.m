function [ r,f ] = GetReward( x, goalState )
% MountainCarGetReward returns the reward at the current state
% x: a vector of position and velocity of the car
% r: the returned reward.
% f: true if the car reached the goal, otherwise f is false
    
positionx = x(1);
positiony = x(2);

r = -1;
f = false;
% 0 in case of success, -1 for all other moves
if( positionx >= goalState(1) && positiony >= goalState(2)) 
	r = 0;
    f = true;
end

   


    
   


    
