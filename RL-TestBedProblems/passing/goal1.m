<<<<<<< HEAD
%% Nueva adaptación de goal1.m.-
function [ goal, bi, area_fin ] = goal1( conf , posicion_b , tx , ty , ballState )

% Goal inicial.-
goal     = false;
area_fin = 0;

% Centro del target.-
cx = conf.Pt(1);
cy = conf.Pt(2);

% Posición de la Bola.-
x = posicion_b(1);
y = posicion_b(2);

% Área de la elipse.-
% area_e1 = ((1/conf.a1) * (x - cx) / conf.r1)^2 + ((1/conf.b1) * (y - cy) / conf.r1)^2;
% area_e2 = ((1/conf.a2) * (x - cx) / conf.r2)^2 + ((1/conf.b2) * (y - cy) / conf.r2)^2;
area_e3 = ((1/conf.a3) * (x - (cx + tx) ) / conf.r3)^2 + ((1/conf.b3) * (y - (cy + ty) ) / conf.r3)^2;

if ballState == 3
    if area_e3 <= 1
        area_fin = 3;
        goal     = true;
    end
end
=======
%% Nueva adaptación de goal1.m.-
function [ goal, bi, area_fin ] = goal1( conf , posicion_b , tx , ty , ballState )

% Goal inicial.-
goal     = false;
area_fin = 0;

% Centro del target.-
cx = conf.Pt(1);
cy = conf.Pt(2);

% Posición de la Bola.-
x = posicion_b(1);
y = posicion_b(2);

% Área de la elipse.-
% area_e1 = ((1/conf.a1) * (x - cx) / conf.r1)^2 + ((1/conf.b1) * (y - cy) / conf.r1)^2;
% area_e2 = ((1/conf.a2) * (x - cx) / conf.r2)^2 + ((1/conf.b2) * (y - cy) / conf.r2)^2;
area_e3 = ((1/conf.a3) * (x - (cx + tx) ) / conf.r3)^2 + ((1/conf.b3) * (y - (cy + ty) ) / conf.r3)^2;

if ballState == 3
    if area_e3 <= 1
        area_fin = 3;
        goal     = true;
    end
end
>>>>>>> origin/thesis
bi = [x,y];