function V_FLC = controller_dribbling (X,Vr_min,Vr_max, controllerType)

ro   = X(1);
gama = X(2);
fi   = X(3);
dbt   = X(4);


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
 
if ~controllerType && ro<100
    Vx     = Vr_max(1);
    Vy     = -.9*fi;
    Vtheta = -1*fi;
else
    Vx     = Vr_max(1);
    Vy     = -.1*fi;
    Vtheta =  1*gama;
end




% -------------------------------------------------------------------------

V_FLC = clipDLF([ Vx, Vy, Vtheta ],Vr_min,Vr_max);

end
