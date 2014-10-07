function [ Actions ] = ActionTable (Vr_min, V_action_steps, Vr_max, Voffset)
%ActionTable

%actions for the Dribbling
Ax = Vr_min(1)-Voffset : V_action_steps(1) : Vr_max(1);
Ay = Vr_min(2) : V_action_steps(2) : Vr_max(2);
Arot = Vr_min(3) : V_action_steps(3) : Vr_max(3);


X=size(Ax,2);
Y=size(Ay,2);
R=size(Arot,2);

Actions=zeros(X*Y*R, 3);
index=1;

for x=1:X   
for y=1:Y
for r=1:R
    Actions(index,1)=Ax(x);
    Actions(index,2)=Ay(y);
    Actions(index,3)=Arot(r);
    index=index+1;
end
end
end

% 
% Actions(:,1) = Ax';
% Actions(:,2) = Ay';
% Actions(:,3) = Arot';


