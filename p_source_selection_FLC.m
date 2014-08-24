function [ a ] = p_source_selection_FLC( Q, s, epsilon, at, p)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

%p=0; % p= 1 for gready from source policy, 0 to learn from scratch

%Method 1 DLF acciones vecinas
ab = GetBestAction(Q,s);
a = round((ab*(1-p) + at*p));

if a>6 || a<1 
    at=a; 
end


% Method 7
% if (rand()>p) 
%     a = e_greedy_selection(Q,s,epsilon);
% else
%     a=at;
% end


% Method 6
%p=0; % 1 for gready from source policy, 0 to learn from scratch
% w = 0.01*p;
% a = GetBestAction(Q+w*Qs, s);  