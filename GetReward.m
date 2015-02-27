function [r,f] = GetReward( x,maxDistance, th_max, Vr_max, faults )
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if the ball is far, otherwise f is false

Vxrmax=Vr_max(1) * 0.9;

Pr = x(1);
Pb = x(2); 
Vb = x(3);
Vr = x(4);
ro = x(5);
dV = x(6);
gama  = x(7);
fi = x(8);

f=false;

angleFactor=0.3;

thres = [ro  abs(gama) abs(fi)] > th_max;

% if ro>th_max(1) || Vr < Vxrmax
%     r(1) = -( (1-Vr/Vxrmax) + ro/th_max(1) );
% else
%     r(1) = Vr/Vxrmax;
% end

if sum(thres)~=0 || Vr < Vxrmax
    r(1) = - ( (1-Vr/Vxrmax) + sum(thres .* [ro abs(gama) abs(fi)] .*1/th_max) );
else
    r(1) = Vr/Vxrmax;
end


if abs(fi) > angleFactor*th_max(3)
    r(2) = -1;
else
    r(2) = 1 + ( 1 - abs(fi)/(angleFactor*th_max(3)) );
end

if abs(gama) > angleFactor*th_max(2) || abs(fi) > angleFactor*th_max(3)
    r(3) = -1;
else
    r(3) = 1 + ( 1 - abs(gama)/(angleFactor*th_max(2)) ) + ( 1 - abs(fi)/(angleFactor*th_max(3)) );
end


if Pb  > maxDistance %|| Pb > maxDistance
    f = true;
%elseif abs(gama) > 90   ||  abs(fi) > 150 
%    f = true;
end
   
