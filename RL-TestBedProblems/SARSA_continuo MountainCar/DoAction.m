function [ xp ] = DoAction( force, x, cfg)
%MountainCarDoAction: executes the action (a) into the mountain car
%environment
% a: is the force to be applied to the car
% x: is the vector containning the position and speed of the car
% xp: is the vector containing the new position and velocity of the car

position_x = x(1);
position_y = x(2);
speed_x    = x(3); 
speed_y    = x(4); 


% bounds for position
% bxleft=cfg.feature_min(1); 
% bxright=cfg.feature_max(1); 
% 
% % bounds for speed
% bsxleft=cfg.feature_min(2); 
% bsxright=cfg.feature_max(2);
 
speedt1(1) = speed_x + (0.001*force(1)) + (-0.0025 * cos( 3.0*position_x));	 
speedt1(1) = speedt1(1) * 0.999; % thermodynamic law, for a more real system with friction.
speedt1(2) = speed_y + (0.001*force(2)) + (-0.0025 * cos( 3.0*position_y));	 
speedt1(2) = speedt1(2) * 0.999; % thermodynamic law, for a more real system with friction.

% if(speedt1<bsxleft) 
%     speedt1=bsxleft; 
% end
% if(speedt1>bsxright)
%     speedt1=bsxright; 
% end

xp(3:4) = clipDLF(speedt1, cfg.feature_min(3:4), cfg.feature_max(3:4));

xp(1) = position_x + speedt1(1); 
xp(2) = position_y + speedt1(2); 

if(xp(1)<=cfg.feature_min(1)|| xp(1)>=cfg.feature_max(1))
     xp(3)=0.0;
end
if(xp(2)<=cfg.feature_min(2)|| xp(2)>=cfg.feature_max(2))
     xp(4)=0.0;
end
xp = clipDLF(xp, cfg.feature_min, cfg.feature_max);
