function [Pr Pb Vb]=mov1d(Pr,Pb,Vb,Vr,dt,Fr,NoiseBall)


Pr= Pr + Vr*dt;
Vbp= sqrt( (Vb^2) - (Vb*2*Fr*dt) );
    if abs(imag(Vbp))>0
        Vbp=0;
    end
    
Pbp= Pb + Vbp*dt;

if abs(Pbp-Pr)<100 % si el robot está muy cerca de la bola la golpea y le da nueva velocidad
    Vb=10*Vr;
    Vb = Vb + Vb*NoiseBall*randn(1,1);
    if Vb<0
        Vb = 0;
    end
    Pb= Pb +Vb*dt;
else
    Vb=Vbp;
    Pb=Pbp;
end

  