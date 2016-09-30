function [a, p] = p_source_selection( Q,T, s, RLparam, a_sh, beta, sync, rnd)

% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

if ~sync.expl, rnd.expl=rand(); end
if ~sync.TL, rnd.TL=rand(); end

N = size(Q,2); % number of actions
Qs=Q(s,:);
%a_best = GetBestAction(Q,s);

a_source = a_sh;

RLparam.softmax=beta;
[a_target, P] = softmax_selection(Qs, T, s, RLparam, rnd.expl);
a_target = clipDLF( round(GetBestAction(Q,s) + RLparam.aScale*rnd.nash*beta), 1,N );

if RLparam.softmax <= 0
    a_target = e_greedy_selection(Q, s, RLparam.epsilon, rnd.expl);
end

if (rnd.TL >= beta) 
    a = a_target; 
else
    a = a_source;
end

p=P(a);
p = clipDLF( p - ( (N*p-1)/(N*(1-N)) + 1/N ), 0,1);


%neashNDist = normpdf(1:nActions, a_sh, RLparam.aScale*(1 - RLparam.p + 100*realmin));
%RLparam.softmax=0;
%[a_source, ~] = softmax_selection(neashNDist, 0, s, RLparam, rnd.nash);
%a_source = clipDLF( round(a_sh + 2*rnd.nash*(1 - RLparam.p)), 1,nActions );
%a_target = clipDLF( round(GetBestAction(Q,s) + 1*rnd.nashExpl* RLparam.epsilon), 1,nActions );

