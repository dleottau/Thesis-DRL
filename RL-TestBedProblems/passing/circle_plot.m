function circle_plot(x,y,a,b,r,tx,ty,h_figur,color)
% x and y are the coordinates of the center of the circle
% r is the radius of the circle
% 0.01 is the angle step, bigger values will draw the circle faster but
% you might notice imperfections (not very smooth)

figure(h_figur)
ang = 0:0.01:2*pi;
xp  = a * r * cos(ang);
yp  = b * r * sin(ang);

plot(x+xp+tx,y+yp+ty,color,'LineWidth',2);
end