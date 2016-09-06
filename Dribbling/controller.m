function V_FLC = controller (x,Vr_min,Vr_max)

ro = x(5);
gama  = x(7);
fi = x(8);

%Vx=1.3*ro*cosd(gama);
Vx= 2*ro - 0.5*abs(gama) - 0.5*abs(fi);

Vy=-1*fi; 
%Vy=-10*fi;

%Vtheta=(gama-0.3*fi)*1.5; 
Vtheta=gama-0.3*fi;

V_FLC = [ Vx, Vy, Vtheta ];
V_FLC = clipDLF(V_FLC,Vr_min,Vr_max);

