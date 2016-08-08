function [ r,f ] = GetReward(x,xt,goal,steps);
% GetReward returns the reward at the current state
% x: a vector of position of the last arm of the robot
% r: the returned reward.
% f: true if the car reached the goal, otherwise f is false
  


penalty = 1.0;
f       = false;
T1      = x(1);
T2      = x(2);
T3      = x(3);
T4      = x(4);

%xt(3)=xt(3)*2;
%goal(3)=goal(3)*2;
e_dist = dist(xt,goal');


%  if ( xf>0 && T2>0  )
%       penalty =  penalty + abs(T2);
%  end
%   
%  if ( xf>0 && T3>0 )
%       penalty =  penalty + abs(T3);
%  end
% 
% if ( xf<0 && T2<0   )
%      penalty =  penalty + abs(T2);
% end
% 
% if ( xf<0 && T3<0 )
%      penalty =  penalty + abs(T3);
% end

%   if ( xf>0 && sign(T2)>0 && sign(T3)>0  )
%        penalty =  10 + abs(T2) + abs(T3);
%   end
%   
%   if ( xf<0 && sign(T2)<0 && sign(T3)<0  )
%        penalty =  10 + abs(T2) + abs(T3);
%   end

if (T2<0)
    penalty =  10 + abs(rad2deg(T2))*0.1;
end

r = -((e_dist^5)/1000.0) * (penalty);
r = r /10;



if ( e_dist<=1 && penalty==1)    
    r =  (10^8)  / (1 + e_dist^2);         
    f =  true;
end

    
   


    
