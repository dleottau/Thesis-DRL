function [ a] = p_source_selection_FLC( Q, s, RLparam, a_sh, nash, sync, rnd)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

if sync.nash<=0, rnd.nash=randn(); end
if sync.nashExpl<=0, rnd.nashExpl=randn(); end
if sync.TL<=0, rnd.TL=rand(); end

actions = size(Q,2);
%a_best = GetBestAction(Q,s);

if nash==1 %if nearby action sharing
    a_source = clipDLF( round(a_sh + 2*rnd.nash*(1 - RLparam.p)), 1,actions );
    a_target = clipDLF( round(GetBestAction(Q,s) + 1*rnd.nashExpl* RLparam.epsilon), 1,actions ); 
else
    a_source = a_sh;
    if RLparam.boltzmann > 0
        a_target = softmax_selection(Q,s,RLparam.boltzmann);
    else
        a_target = e_greedy_selection(Q,s,RLparam.epsilon);
    end
    
end

if (rnd.TL > RLparam.p) 
    a = a_target; 
else
    a = a_source;
end

% % Method 7
% if (rand()> RLparam.p) 
%     a = e_greedy_selection(Q,s,RLparam.epsilon);
% else
%     a=a_sh;
% end


% Method 2 DLF
% if (rand() > RLparam.p) 
%     a = clipDLF( round(ab + 1*randn()* RLparam.p), 1,actions ); 
%     %a = e_greedy_selection(Q,s,RLparam.epsilon);
% else
%     a = clipDLF( round(a_sh + 2*randn()*(1 - RLparam.p)), 1,actions );
%     a=a_sh;
% end

