function [ Actions] = ActionTable ( conf )

%ActionTable

%actions for the Dribbling
Ax = conf.Vr_min(1) : conf.V_action_steps(1) : conf.Vr_max(1);

%Arot = conf.Vr_min(2) : conf.V_action_steps(2) : conf.Vr_max(2);
% Just enable next line if want nonlinear discretization
%Arot = Arot.*(1-gaussmf(Arot,[conf.Vr_max(2)/4, abs(conf.Vr_max(2)+conf.Vr_min(2))/2]));

Arot = [-conf.deltaVw 0 conf.deltaVw];

Actions.x = Ax';
% Actions(:,2) = Ay';
Actions.w = Arot';

ct=1;
for i=1:length(Ax)
    for j=1:length(Arot)
        Actions.cent(ct,:)=[Ax(i) Arot(j)];
        ct=ct+1;
    end
end


% Ax=Ax';Arot=Arot';
% ct=1;
% for i=1:size(Ax,1)
%     for j=1:size(Arot,1)
%         Ac{1,ct}=[Ax(i) Arot(j)];
%         ct=ct+1;
%     end
% end

 %uncomment for centralized agent
% X=size(Ax',2);
% % Y=size(Ay,2);
% R=size(Arot',2);
% 
% Actions=zeros(X*R, 3);
% index=1;

% for x=1:X   
% % for y=1:Y
% for r=1:R
%     Actions(index,1)=Ax(x);
% %     Actions(index,2)=Ay(y);
%     Actions(index,2)=Arot(r);
%     index=index+1;
% end
% % end
% end




