function V_FLC = FLC_dribbling (w,x,Vr_min,Vr_max)


f2d=w(7);g23m=w(8);g23d=w(9);g14m=w(10);g14d=w(11);

ro = x(5);
gama  = x(7);
fi = x(8);


% Vy=-1*sigmo(ro,w(1),w(2))*fi;
% 
% if ro<200
%     Kfi=sigmo(ro,w(3),-w(4));
% else
%     Kfi=sigmo(ro,w(5),w(6));
% end
% Vtheta=gama-0.3*Kfi*fi; %
% 
% f2=gauss_bell(fi, 0, f2d);
% if fi<0, f1=1-f2; else, f1=0;end
% if fi>=0, f3=1-f2; else, f3=0;end
% 
% g1= gauss_bell(gama, -g14m, g14d);
% g2= gauss_bell(gama, -g23m, g23d);
% g3= gauss_bell(gama, g23m, g23d);
% g4= gauss_bell(gama, g14m, g14d);
% %%%Z=0; L=0.6; H=0.9;
% Z=0; L=0.9; H=3.0;
% k1= (L*f1*g1 + Z*f2*g1 + Z*f3*g1 + H*f1*g2 + H*f2*g2 + Z*f3*g2 + Z*f1*g3 + H*f2*g3 + H*f3*g3 + Z*f1*g4 + Z*f2*g4 + L*f3*g4)/(f1*g1 + f2*g1 + f3*g1 + f1*g2 + f2*g2 + f3*g2 + f1*g3 + f2*g3 + f3*g3 + f1*g4 +f2*g4 + f3*g4);
% Vx=k1*ro;

%Vx=1.2*ro*cosd(gama);
Vx= 3.6*ro;
%Vy=-1*fi; 
Vy=-10*fi;
%Vtheta=gama-0.3*fi; 
Vtheta=gama-0.4*fi;

V_FLC = [ Vx, Vy, Vtheta ];
V_FLC = clipDLF(V_FLC,Vr_min,Vr_max);

