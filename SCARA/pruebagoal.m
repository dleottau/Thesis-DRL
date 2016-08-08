
l1=8.625;				% distance between frame '1' and '2'
l2=l1;					% distance between frame '2' and '3'
l3=6.125;				% distance between frame '3' and 'tool'
rmax=l1+l2+l3;						% maximum distance between (0,0) and tool frame
rmin=(l2^2+(l1-l3)^2)^0.5;		% minimum distance between (0,0) and tool frame
hold on

arc=(0:1:180)*pi/180;		% plot desired workspace
arc2=(180:-1:0)*pi/180;
plot([rmax*cos(arc) rmin*cos(arc2) rmax],[rmax*sin(arc) rmin*sin(arc2) 0], 'Color',[.8 .4 .2])

plot([rmax*cos(arc) rmin*cos(arc2) rmax],[rmax*sin(arc) rmin*sin(arc2) 0],'Color',[.8 .4 .2])
for i=1:1000
    [x y]=randgoal();
    plot(x,y,'.r')
    
end
axis([-40 40 -40 40])
hold off
