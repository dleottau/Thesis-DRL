function [ xp ] = DoAction( force, x, cfg)
%MountainCarDoAction: executes the action (a) into the mountain car
%environment
% a: is the force to be applied to the car
% x: is the vector containning the position and speed of the car
% xp: is the vector containing the new position and velocity of the car

position_x = x(1);
speed_x    = x(2); 

% bounds for position
bxleft=cfg.feature_min(1); 
bxright=cfg.feature_max(1); 

% bounds for speed
bsxleft=cfg.feature_min(2); 
bsxright=cfg.feature_max(2);
 
speedt1= speed_x + (0.001*force) + (-0.0025 * cos( 3.0*position_x));	 
speedt1= speedt1 * 0.999; % thermodynamic law, for a more real system with friction.


if(speedt1<bsxleft) 
    speedt1=bsxleft; 
end
if(speedt1>bsxright)
    speedt1=bsxright; 
end

post1 = position_x + speedt1; 

if(post1<=bxleft)
    post1=bxleft;
    speedt1=0.0;
end

xp=[];
xp(1) = post1;
xp(2) = speedt1;