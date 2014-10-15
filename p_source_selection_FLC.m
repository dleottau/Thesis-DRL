function [ a] = p_source_selection_FLC( Q, s, RLparam, at, Q_INIT)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

actions = size(Q,2);
ab = GetBestAction(Q,s);

% % Method 7
% if (rand()> RLparam.p) 
%     a = e_greedy_selection(Q,s,RLparam.epsilon);
% else
%     a=at;
% end


%Method 1 DLF
% if (rand()>p) 
%     a = ab;
% else
%     a = at;
% end


% Method 2 DLF
if (rand() > RLparam.p) 
    a = clipDLF( round(ab + 1*randn()* RLparam.p), 1,actions ); %e_greedy_selection(Q,s,epsilon);
else
    a = clipDLF( round(at + 2*randn()*(1 - RLparam.p)), 1,actions );
end

