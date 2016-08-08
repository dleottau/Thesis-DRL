function V_FLC = controller_dribbling (X,Vr_min,Vr_max)

% f2d = w(7);g23m=w(8);g23d=w(9);g14m=w(10);g14d=w(11);

% keyboard

ro   = X(1);
gama = X(2);
fi   = X(3);

Vx     = Vr_max(1)-0.3*abs(gama)-0.3*abs(fi);
Vy     = 0;
Vtheta = -0.0*ro + 1.5*gama - 0.4*fi; 

% V_FLC = [ Vx,Vtheta ];

% -------------------------------------------------------------------------
V_FLC = [ Vx, Vy, Vtheta ];
% -------------------------------------------------------------------------
V_FLC = clipDLF(V_FLC,Vr_min,Vr_max);