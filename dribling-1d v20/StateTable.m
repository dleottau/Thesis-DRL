function [ States ] = StateTable
%BuildStateList builds a state list from a state matrix

% ro0=10; % 20 mm
% N=6; % discretization levels
% roN=500;
% 
% n=log(roN/ro0)/log(N);
% 
% ro = zeros(1,N);
% ro(1)=ro0;

%0 20 50 90

% for i=2:N
%     ro(i) = ro0*i^n;
% end

%dV=-100:20:100; %OK con esta converge en 350s y Vavg 70
%dV=[-100 -50 -25 0 50 100 200]; %OK con esta converge en 250 s y Vavg 70

ro=0:50:500;
dV=[-10 10];  %OK con esta converge en 200 s y Vavg 70
 
N=size(ro,2);
M=size(dV,2);


States=[];
index=1;


for i=1:N   
%for j=1:M
    States(index,1)=ro(i);
    %States(index,2)=dV(j);
    index=index+1;
%end
    
end
