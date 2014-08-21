function [ Vx, Vy, Vtheta ] = FLC_dribbling (w,x,Voffset,Vr_max)

Vx_max = Vr_max(1);
Vy_max = Vr_max(2);
Vrot_max = Vr_max(3);

f2d=w(7);g23m=w(8);g23d=w(9);g14m=w(10);g14d=w(11);

ro = x(5);
gama  = x(7);
fi = x(8);


Vy=-10*sigmo(ro,w(1),w(2))*fi;
Vy=sat(Vy,-Vy_max,Vy_max); %

if ro<300
    Kfi=sigmo(ro,w(3),-w(4));
else
    Kfi=sigmo(ro,w(5),w(6));
end
Vtheta=sat(gama-0.4*Kfi*fi,-Vrot_max,Vrot_max); %
f2=gauss_bell(fi, 0, f2d);
if fi<0, f1=1-f2; else, f1=0;end
if fi>=0, f3=1-f2; else, f3=0;end

g1= gauss_bell(gama, -g14m, g14d);
g2= gauss_bell(gama, -g23m, g23d);
g3= gauss_bell(gama, g23m, g23d);
g4= gauss_bell(gama, g14m, g14d);
k1= (0.6*f1*g1 + 0*f2*g1 + 0*f3*g1 + 0.9*f1*g2 + 0.9*f2*g2 + 0*f3*g2 + 0*f1*g3 + 0.9*f2*g3 + 0.9*f3*g3 + 0*f1*g4 +0*f2*g4 + 0.6*f3*g4)/(f1*g1 + f2*g1 + f3*g1 + f1*g2 + f2*g2 + f3*g2 + f1*g3 + f2*g3 + f3*g3 + f1*g4 +f2*g4 + f3*g4);
Vx=1.2*ro;
Vx=sat(Vx,Voffset,Vx_max);% 


