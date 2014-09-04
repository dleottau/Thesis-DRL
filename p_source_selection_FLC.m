function [ a, ft ] = p_source_selection_FLC( Q, s, epsilon, at, p, Q_INIT)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

actions = size(Q,2);
ab = GetBestAction(Q,s);

% % Method 7
% if (rand()>p) 
%     a = e_greedy_selection(Q,s,epsilon);
% else
%     a=at;
% end
% 

%Method 1 DLF
% if (rand()>p) 
%     a = ab;
% else
%     a = at;
% end


% Method 2 DLF
if (rand()>p) 
    a = clipDLF( round(ab + 1*randn()*p), 1,actions ); %e_greedy_selection(Q,s,epsilon);
else
    a = clipDLF( round(at + 2*randn()*(1-p)), 1,actions );
end



% Method 3 DLF
% a = clipDLF( round(at + randn()*(1-p)), 1,actions );
% if (rand()>p)  && Q(s,ab)~=Q_INIT
%     a=ab;
% end

%a = round((ab*(1-p) + at*p));

%if a>6 || a<1 
%    at=a; 
%end




% Method 6
%p=0; % 1 for gready from source policy, 0 to learn from scratch
% w = 0.01*p;
% a = GetBestAction(Q+w*Qs, s);  


ft=0;
if a==at && p>0.5
    ft=1; 
end