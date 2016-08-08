function [ goal  ] = randgoal()


rmax=38;						    % maximum distance between (0,0) and tool frame
rmin=20;		                    % minimum distance between (0,0) and tool frame
amax=4;
amin=2;


phi = (2*rand()-1)*pi;
radius = ((rmax-rmin)/2.0) * (2*rand()-1) +((rmax+rmin)/2.0);


x = abs(radius * cos(phi));
y = abs(radius * sin(phi));
z =  (amax-amin)*rand() + amin;

goal =[x y 2];
%goal =[x y z];