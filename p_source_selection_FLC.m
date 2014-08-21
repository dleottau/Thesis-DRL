function [ a ] = p_source_selection_FLC( Q, s, epsilon, a, p)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% a transferred action
% p probability for choosing transferred action


% Method 7
p=0; % 1 for gready from source policy, 0 to learn from scratch
if (rand()>p) 
    a = e_greedy_selection(Q,s,epsilon);
end


% Method 6
%p=0; % 1 for gready from source policy, 0 to learn from scratch
% w = 0.01*p;
% a = GetBestAction(Q+w*Qs, s);  