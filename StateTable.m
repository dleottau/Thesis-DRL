function [ States ] = StateTable
%BuildStateList builds a state list from a state matrix

ro=0:50:600;

%gama=[-45 -10 0 10 45];
%fi=[-60 -15 0 15 60];
gama=-30:10:30;
fi= -30:10:30;

%dV=[-50 -25 0 50 100 200];  %OK con esta converge en 200 s y Vavg 70
%Vr=[20 40 60 80 100];
 
N=size(ro,2);
M=size(gama,2);
O=size(fi,2);

States=[];
index=1;

for i=1:N   
for j=1:M
for k=1:O
    States(index,1)=ro(i);
    States(index,2)=gama(j);
    States(index,3)=fi(k);
    index=index+1;
end
end
end
