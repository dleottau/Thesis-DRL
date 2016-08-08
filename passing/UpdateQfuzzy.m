function [ Q, trace, U, Qv] = UpdateQfuzzy(FV, r, Q, trace, RLparam, Qv)
% [ Q, e_trace] = UpdateSARSA( FV, a, r, FVp, ap, Q, e_trace, RLparam)
% Update the Q parameter vector and return it using Qfuzzy
% MF: previous fuzzy state before taking action (a)
% MFp: current fuzzy state after action (a)
% r: reward received from the environment after taking action (a) in state
%                                             s and reaching the state sp
% a:  the last executed action
% q: the current q parameter vector
% alpha: learning rate
% gamma: discount factor
% lambda: eligibility trace decay factor
% trace : eligibility trace vector

MF      = FV/sum(FV);
[S, A]  = size(Q);
[qv, a] = max(Q,[],2);
V       = sum( qv .* MF );
TD      = r + RLparam.gamma * V  - Qv;

% Eligibility traces
for i=1:S
    trace(i,a(i)) = (trace(i,a(i)) + MF(i));
end

Q     = Q + TD * trace * RLparam.alpha;  %fixed learning rate
trace = RLparam.lambda*trace;

% Get Global Action
[qv, a] = max(Q,[],2);
U       = sum( MF .* a);

% Get Q value
Qv = sum( qv .* MF );