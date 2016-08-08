function [r,f] = GetReward( x,maxDistance, time, Vth, Rmin, ro_max)
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if the ball is far, otherwise f is false

Pr = x(1);
Pb = x(2); 
Vb = x(3); 
Vr = x(4); 

ro = Pb-Pr;
dV = Vb-Vr;

Vavg = Pr/time;
%maxTime = maxDistance/Vth;
Vx_max=100;
Vx_offset=20;

f=false;

%R0
% if ro>ro_max 
%     r=-1;
% elseif Vr > Vth
%     r=1;
% else 
%     r=-1;
% end

%R1
% if ro>ro_max
%  r = -( (Vx_max/Vr * ro/ro_max)^2);
% else 
%     r= (Vr/Vx_max)^2; 
% end

% %R1, r>
if ro>ro_max
    r = -(ro/ro_max + Vx_max/Vr);
else 
    r= (1+Vr/Vx_max);
end

% if ro>ro_max
%     r = -(2-Vr/Vx_max) * exp(ro/ro_max);
% else 
%     r = exp(Vr/(Vx_max*0.6))-1;
% end



% %R2
% if ro>ro_max
%     %r = -(2*Vx_max-Vr)*(ro/ro_max);
%  else 
%     r= Vr;
% end

%R3
% if ro>ro_max
%     r = -(Vx_max-Vr)^(ro/ro_max);
% else 
%     r= Vr  * exp(Vr/(Vx_max*1));
% end

%R4
% if ro>ro_max
%     r = -(2*Vx_max-Vr)-(ro-ro_max);
% else 
%     r= Vr;
% end


% %R5
% if ro>ro_max
%     r = -Vx_max/Vr*exp(ro/ro_max);
% else 
%     r= (Vr/Vx_max)*exp(-ro/(ro_max));
% end

%R6
% if ro>ro_max
%     r = -Vx_max/Vr*exp(ro/ro_max);
% else 
%     r = exp(Vr/(Vx_max*0.6))-1;
% end



% SI se usan dos estados: pho,dV, funciona mejor la recompensa -1,1,-2
% SI se usa un solo estado: pho, funciona mejor la recompensa -2,1,-1

%r = -ro/Vr;


if Pr > maxDistance
    f = true;
end
     
