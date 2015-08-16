function [ xp ] = DoAction( force, x, cfg)
%MountainCarDoAction: executes the action (a) into the mountain car
%environment
% a: is the force to be applied to the car
% x: is the vector containning the position and speed of the car
% xp: is the vector containing the new position and velocity of the car

position_x = x(1);
speed_x    = x(2);
position_y = x(3);
speed_y    = x(4); 

 
speedt1x = speed_x + (0.001*force(1)) + (-0.0025 * cos( 3.0*position_x));	 
speedt1x = speedt1x * 0.999; % thermodynamic law, for a more real system with friction.
speedt1y = speed_y + (0.001*force(2)) + (-0.0025 * cos( 3.0*position_y));	 
speedt1y = speedt1y * 0.999; % thermodynamic law, for a more real system with friction.

speedt1x = clipDLF(speedt1x, cfg.feature_min(2), cfg.feature_max(2));
speedt1y = clipDLF(speedt1y, cfg.feature_min(4), cfg.feature_max(4));

position_x = position_x + speedt1x; 
position_y = position_y + speedt1y; 

if(position_x<=cfg.feature_min(1)|| position_x>=cfg.feature_max(1))
     speedt1x=0.0;
end
if(position_y<=cfg.feature_min(3)|| position_y>=cfg.feature_max(3))
     speedt1y=0.0;
end

xp(1) = position_x; 
xp(2) = speedt1x;
xp(3) = position_y;
xp(4) = speedt1y;

xp = clipDLF(xp, cfg.feature_min, cfg.feature_max);
