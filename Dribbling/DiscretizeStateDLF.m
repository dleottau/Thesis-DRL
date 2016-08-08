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

x(1) = clipDLF( xp(5), cores.ro(1), cores.ro(size(cores.ro,2)) )  - cores.ro(1);
x(2) = clipDLF( xp(7), cores.gama(1), cores.gama(size(cores.gama,2)) )  - cores.gama(1);
x(3) = clipDLF( xp(8), cores.fi(1), cores.fi(size(cores.fi,2)) )  - cores.fi(1);

%x = round(x./feature_step(1));
x = round(x./feature_step);
x = x.*div_disc;
s=sum(x)+1;


%if s<0 || s> size(cores.ro,2)*size(cores.gama,2)*size(cores.fi,2)
%    s;
%end