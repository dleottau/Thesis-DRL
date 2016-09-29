function s  = DiscretizeStateDLF(xp, cores, feature_step,div_disc)

% Pr = x(1);
% Pb = x(2); 
% Vb = x(3);
% Vr = x(4);
% ro = x(5);
% dV = x(6);
% gama  = x(7);
% fi = x(8);

%xp(7)=0;
%xp(8)=0;

x(1) = clipDLF( xp(5)  , cores.mean.ro(1)   , cores.mean.ro(size(cores.mean.ro,2)) )     - cores.mean.ro(1);
x(2) = clipDLF( xp(7)  , cores.mean.gama(1) , cores.mean.gama(size(cores.mean.gama,2)) ) - cores.mean.gama(1);
x(3) = clipDLF( xp(8)  , cores.mean.fi(1)   , cores.mean.fi(size(cores.mean.fi,2)) )     - cores.mean.fi(1);
x(4) = clipDLF( xp(15) , cores.mean.dBT(1)  , cores.mean.dBT(size(cores.mean.dBT,2)) )   - cores.mean.dBT(1);

x = round(x ./ feature_step);
x = x .* div_disc;
s = sum(x) + 1;