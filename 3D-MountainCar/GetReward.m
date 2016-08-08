function [ r,f ] = GetReward( x, goalState, DRL )
% MountainCarGetReward returns the reward at the current state
% x: a vector of position and velocity of the car
% r: the returned reward.
% f: true if the car reached the goal, otherwise f is false
    
positionx = x(1);
positiony = x(3);

f = false;

if DRL
    
    r = [-1 -1];
    if positionx >= goalState(1)
        r(1)=0;
    end
    if positiony >= goalState(2)
        r(2)=0;
    end
    if( positionx >= goalState(1) && positiony >= goalState(2)) 
        f = true;
    end
    
else
    
    r = -1;
    % 0 in case of success, -1 for all other moves
    if( positionx >= goalState(1) && positiony >= goalState(2)) 
        r = 0;
        f = true;
    end
    
end
    



   


    
   


    
