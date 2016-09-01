function [a, p] = p_source_selection_FLC( Q,T, s, RLparam, a_sh, nash, sync, rnd)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

p=1;

if sync.nash<=0, rnd.nash=rand(); rnd.nashExpl=randn(); end
if sync.expl<=0, rnd.expl=rand(); end
if sync.TL<=0, rnd.TL=rand(); end

nActions = size(Q,2);
Qs=Q(s,:);
%a_best = GetBestAction(Q,s);

if nash==1 %if nearby action sharing
    [a_target, p] = softmax_selection(Qs, T, s, RLparam, rnd.expl);
    if RLparam.softmax <= 0
        a_target = e_greedy_selection(Q, s, RLparam.epsilon, rnd.expl);
    end
    
    neashNDist = normpdf(1:nActions, a_sh, RLparam.aScale*(1 - RLparam.p + 100*realmin));
    RLparam.softmax=0;
    [a_source, ~] = softmax_selection(neashNDist, 0, s, RLparam, rnd.nash);
    %a_source = clipDLF( round(a_sh + 2*rnd.nash*(1 - RLparam.p)), 1,nActions );
    %a_target = clipDLF( round(GetBestAction(Q,s) + 1*rnd.nashExpl* RLparam.epsilon), 1,nActions );
else
    a_source = a_sh;
    [a_target, p] = softmax_selection(Qs, T, s, RLparam, rnd.expl);
    if RLparam.softmax <= 0
        a_target = e_greedy_selection(Q, s, RLparam.epsilon, rnd.expl);
    end
end


if (rnd.TL >= RLparam.p) 
    a = a_target; 
else
    a = a_source;
end

