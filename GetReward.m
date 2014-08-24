function [r,f] = GetReward( x,maxDistance, time, Vth, th_max, Vr_max )
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if the ball is far, otherwise f is false

Vxrmax=Vr_max(1);

Pr = x(1);
Pb = x(2); 
Vb = x(3);
Vr = x(4);
ro = x(5);
dV = x(6);
gama  = x(7);
fi = x(8);

f=false;

xb = abs(ro*cosd(gama));
yb = abs(ro*sind(gama));
yfi = abs(ro*sind(fi));


if ro>th_max(1) || abs(gama)>th_max(2) || abs(fi)>th_max(3) || Vr < 0.81*Vxrmax
    r=-1;
else
    r=1;
end

% if ro>th_max(1) || abs(gama)>th_max(2) || abs(fi)>th_max(3) || Vr < 0.9*Vxrmax
%     r=-1;
% else
%     r=1;
% end


% if ro>th_max(1) || abs(gama)>th_max(2) || abs(fi)>th_max(3)
%     r=-2;
% elseif Vr > Vth
%     r=1;
% else 
%     r=-1;
% end


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
   
