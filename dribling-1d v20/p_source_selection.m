function [ a ] = p_source_selection( Q, s, epsilon, Qs, p)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% Qs policy of the source task
% p probability for choosing best action from Qs



% Method 7
%p=0; % 1 for gready from source policy, 0 to learn from scratch
% if (rand()<p) 
%     a = GetBestAction(Qs,s);  
% else
%     a = e_greedy_selection(Q,s,epsilon);
% end


% Method 6
%p=0; % 1 for gready from source policy, 0 to learn from scratch
w = 0.01*p;
a = GetBestAction(Q+w*Qs, s);  
