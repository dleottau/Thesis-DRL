function [ xp ro ] = DoAction( action, x, dt, NoiseBall, NoiseRobotVel, Voffset)
%DribblingDoAction: executes the action (a) into the dribbling1d
%environment

Pr = x(1);
Pb = x(2); 
Vb = x(3);
Vr = x(4);

Fr = 150;

Vr = Vr + action;

Vr = Vr + NoiseRobotVel*Vr*randn(1,1);
    if Vr<Voffset
        Vr = Voffset;
    elseif Vr>100
        Vr = 100;
    end

[Pr Pb Vb]=mov1d(Pr,Pb,Vb,Vr,dt,Fr,NoiseBall);
 
ro = Pb-Pr;
xp=[Pr Pb Vb Vr];



