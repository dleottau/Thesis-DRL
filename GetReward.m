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
%dV = Vb-Vr;
dV = x(6);

Vavg = Pr/time;
maxTime = maxDistance/Vth;
Vx_max=100;

f=false;

if ro>ro_max 
    r=-1;
elseif Vr > Vth
    r=1;
else 
    r=-1;
end

% if ro > ro_max
%     r = -(ro - ro_max) - (2*Vx_max - Vr);
% else
%     r = Vr;
% end

%if ro > ro_max
%    r = -2;
%else
%    r = -(Vx_max-Vr)/Vx_max;
%end

%r = -(Vx_max-Vr);


% SI se usan dos estados: pho,dV, funciona mejor la recompensa -1,1,-2
% SI se usa un solo estado: pho, funciona mejor la recompensa -2,1,-1

%r = -ro/Vr;


if Pr > maxDistance
    f = true;
end
   
