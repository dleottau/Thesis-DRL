%Esta funcion covierte un angulo de grados a radines o radianes a grados
%dado el parametro de entrada 'd2r' o 'r2d' respectivamente, luego
%hace modulo en pi o 180 del angulo de entrada "angle"
%Manteniendolo siempre en el intervalo -pi, pi  o -180, 180 grados
function angle=moduloPiDLF(angle,string)

if strcmp(string,'d2r')
    angle = angle*pi/180;
    string = 'r2r';
elseif strcmp(string,'r2d')
    angle = angle*180/pi;
    string = 'd2d';
end


if strcmp(string,'d2d')
    angle=mod(angle,360);
    if angle > 180, angle=angle-360; end
elseif strcmp(string,'r2r')
    angle=mod(angle,2*pi);
    if angle > pi, angle=angle-2*pi; end
else disp('Invalid input argument')
end