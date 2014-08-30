function [r,f, r_y] = GetReward( x,maxDistance, th_max, Vr_max )
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if the ball is far, otherwise f is false

Vxrmax=Vr_max(1) * 0.7;

Pr = x(1);
Pb = x(2); 
Vb = x(3);
Vr = x(4);
ro = x(5);
dV = x(6);
gama  = x(7);
fi = x(8);

f=false;

% xb = abs(ro*cosd(gama));
% yb = abs(ro*sind(gama));
% yfi = abs(ro*sind(fi));

thres = [ro  abs(gama) abs(fi)] > th_max;
if sum(thres)~=0 || Vr < Vxrmax
    r = - ( (1-Vr/Vxrmax) + sum(thres .* [ro abs(gama) abs(fi)] .*1/th_max) );
else
    r = Vr/Vxrmax;
end


if abs(fi) > .3*th_max(3)
    r_y = -1;
else
    r_y = 1 + ( 1 - abs(fi)/(.3*th_max(3)) );
end



%if sum(thres)~=0 || Vr < 0.9*Vxrmax
%     r=-1;
% else
%     r=1;
% end




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
   
