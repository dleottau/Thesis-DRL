function [r,f] = GetReward( x,maxDistance, time, Vth, ro_max )
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if the ball is far, otherwise f is false

Pr = x(1);
Pb = x(2); 
Vb = x(3);
Vr = x(4);
ro = x(5);
dV = x(6);
gama  = x(7);
fi = x(8);

Vx_max=100;
f=false;

xb = abs(ro*cosd(gama));
yb = abs(ro*sind(gama));
yfi = abs(ro*sind(fi));

if xb>ro_max || yb>ro_max/4 || yfi>ro_max/4
    r=-2;
elseif Vr > Vth
    r=1;
else 
    r=-1;
end


% if ro>ro_max 
%     r=-2;
% elseif Vr > Vth
%     r=1;
% else 
%     r=-1;
% end


if Pr > maxDistance
    f = true;
end
   
