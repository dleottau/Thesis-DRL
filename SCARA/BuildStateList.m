function [ states ] = BuildStateList
%BuildStateList builds a state list from a state matrix

% state discretization for the robot arm
%angle_div  = (90.0-(-90.0)) / 60.0; % 60 subdivision , step size= 3 degrees
%angle_div  = (90.0-(-90.0)) / 36.0; % 36 subdivision , step size= 5 degrees
%angle_div   = (90.0-(-90.0)) / 10.0; % 10 subdivision , step size= 19 degrees




% All three articulations have the same charactetistics
%x1 = -90:angle_div:90.0;


x1 = [-1 0 1]; %difference in x
x2 = [-1 0 1]; %difference in y
x3 = [-1 0 1]; %difference in z
%x3 = 0:2.5:25;
%x4 = 0:2.5:25;


I=3;
J=3;
K=size(x3,2);
%L=size(x4,2);
states=[];
index=1;
for i=1:I    
    for j=1:J
        for k=1:K           
            %for l=1:L
                    states(index,1)=x1(i);
                    states(index,2)=x2(j);
                    states(index,3)=x3(k);               
                    %states(index,4)=x4(l);               
                    index=index+1;  
            %end         
        end        
    end
end
