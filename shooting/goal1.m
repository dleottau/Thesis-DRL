%% Nueva adaptaci�n de goal1.m.-
function [ goal, bi ] = goal1( conf , posicion_b )

% Goal inicial.-
goal = false;

% Posici�n de la Bola.-
x  = posicion_b(1);
y  = posicion_b(2);
bi = [x,y];

if ( x <= conf.PgoalPostR(1) && abs(y) < (abs(conf.PgoalPostR(2)-conf.PgoalPostL(2))))
    goal = true;
end