%% Nueva adaptación de goal1.m.-
function [ goal, bi ] = goal1( conf , posicion_b , ballState )

% Goal inicial.-
goal     = false;

% Centro del target.-
cx = conf.Pt(1);
cy = conf.Pt(2);

% Posición de la Bola.-
x = posicion_b(1);
y = posicion_b(2);

% Área de la elipse.-
area_e3 = ((1/conf.a3) * (x - cx) / conf.r3)^2 + ((1/conf.b3) * (y - cy) / conf.r3)^2;

if ballState == 3
    if area_e3 <= 1
        goal     = true;
    end
end
bi = [x,y];