function [ xp xo ] = DoAction( action, x, dt, NoiseBall, NoiseRobotVel, NoisePerception, Voffset)
%DribblingDoAction: executes the action (a) into the dribbling1d
%environment

Pr = x(1);
Pb = x(2); 
Vb = x(3);
Vr = x(4);

Fr = 150;
maxDeltaVx=30; %mm/s/Ts

dVelReq = action - Vr;
Vro=action;

if abs(dVelReq)>maxDeltaVx
    Vro = Vr + sign(dVelReq)*maxDeltaVx;
else
    Vro = Vr + dVelReq;
end

Vr = Vro;
Vr = Vr*(clipDLF(1+0.3*randn(), 1-NoiseRobotVel, 1+NoiseRobotVel)); 
Vr = clipDLF(Vr,Voffset,100);    

[Pr Pb Vb] = mov1d(Pr,Pb,Vb,Vr,dt,Fr,NoiseBall);

% Ground thruth state vector
xp=[Pr Pb Vb Vr];

% Observed state vector
np = (rand()*2*NoisePerception - NoisePerception) + 1;
xo(1) = xp(1);
%Adding noise to the ball perception
xo(2) = xp(2)*np;
xo(3) = xp(3)*np;
xo(4) = Vro;




