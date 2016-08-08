function [ ang1 ] = nangle( p1,p2,p3,p4 )

v1 = [p1-p2]';
v2 = [p3-p4]';

% ang(1)*v2(2)-v2(1)*v1(2),v1(1)*v2(1)+v1(2)*v2(2));
ang  = atan2(abs(det([v1,v2])),dot(v1,v2));
ang1 = radtodeg(ang);
ang2 = atan2(v1(1)*v2(2)-v2(1)*v1(2),v1(1)*v2(1)+v1(2)*v2(2));
ang3 = mod(-180/pi*ang2,360);

% m3=[m2(ct,1) m(ct,2)];
% d1=dist(m(ct,:),m3);d2=dist(m2(ct,:),m3);
% ang1(ct,:)=atand(d2/d1);
% ang1(ct,:) = mod(ang, 360);
end