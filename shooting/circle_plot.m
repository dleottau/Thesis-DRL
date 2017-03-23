function [x1, x2, y1, y2] = circle_plot(x,y,a,b,r,ang_i,ang_f,h_figur,color,LW)
% x and y are the coordinates of the center of the circle
% r is the radius of the circle
% 0.01 is the angle step, bigger values will draw the circle faster but
% you might notice imperfections (not very smooth)

figure(h_figur)
% ang = 0:0.01:2*pi;
ang = ang_i:0.01:ang_f;
xp  = a * r * cos(ang);
yp  = b * r * sin(ang);

plot(x+xp,y+yp,color,'LineWidth',LW);


x1 = xp(1)   + x; 
x2 = xp(end) + x;
y1 = yp(1)   + y;
y2 = yp(end) + y;

end