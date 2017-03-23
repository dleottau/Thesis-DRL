function V_FLC = controller_dribbling (X,Vr_min,Vr_max)

ro   = X(1);
gama = X(2);
fi   = X(3);
dbt   = X(4);

%w=[550 0.0085 0 0.062 550 0.06 5 20 10 60 35];
% w=[550 0.0085 0 0.062 550 0.06 5 20 10 80 40];
% f2d=w(7);g23m=w(8);g23d=w(9);g14m=w(10);g14d=w(11);
% 
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
% if fi<0, f1=1-f2; else f1=0;end
% if fi>=0, f3=1-f2; else f3=0;end
% 
% g1= gauss_bell(gama, -g14m, g14d);
% g2= gauss_bell(gama, -g23m, g23d);
% g3= gauss_bell(gama, g23m, g23d);
% g4= gauss_bell(gama, g14m, g14d);
%%%Z=0; L=0.6; H=0.9;
%Z=0; L=0.8; H=1.5;

%k1= (L*f1*g1 + Z*f2*g1 + Z*f3*g1 + H*f1*g2 + H*f2*g2 + Z*f3*g2 + Z*f1*g3 + H*f2*g3 + H*f3*g3 + Z*f1*g4 + Z*f2*g4 + L*f3*g4)/(f1*g1 + f2*g1 + f3*g1 + f1*g2 + f2*g2 + f3*g2 + f1*g3 + f2*g3 + f3*g3 + f1*g4 +f2*g4 + f3*g4);
%Vx=k1*ro;
%Vx=k1*Vr_max(1);
%Vx=2.5*ro*cosd(gama);


% Parámetros Controlador Lineal no optimizados.-----------------------------------------------
%Vx     = Vr_max(1)   - 0.5 * abs(gama) - 0.5 * abs(fi)
%Vy     = -1*fi; 
%Vtheta = gama-0.3*fi;
% -------------------------------------------------------------------------

% Parámetros Controlador Lineal optimizados.--------------------------------------------------
% Vx     = 1.5 * ro   + 0.2 * abs(gama) + 0.4 * abs(fi);
% Vy     = -1  * fi; 
% Vtheta = 1   * gama - 0.4 * fi;
% -------------------------------------------------------------------------

% Parámetros Controlador Lineal optimizados manual.--------------------------------------------------
Vx     = 0.1*dbt  -   0.5*abs(gama)   -   0.5*abs(fi);
Vy     = -10*fi; 
Vtheta =  1*gama    -   0.3*fi;
% -------------------------------------------------------------------------

V_FLC = clipDLF([ Vx, Vy, Vtheta ],Vr_min,Vr_max);

end

function [y]= gauss_bell(x,med,dev)
y=exp( -0.5 * ((x-med).^2)/dev^2 ) +0.0000000000000000001;
end

function [y]= sigmo(x,med,dev)
y=1/( 1 + exp( dev * (x-med) ) );
end