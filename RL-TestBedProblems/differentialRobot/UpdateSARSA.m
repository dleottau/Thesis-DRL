function [ Q, e_trace] = UpdateSARSA( FV, a, r, FVp, ap, Q, e_trace, RLparam, MAapproach)

% UpdateQ update de Qtable and return it using Whatkins QLearing
% s1: previous state before taking action (a)
% s2: current state after action (a)
% r: reward received from the environment after taking action (a) in state
%                                             s1 and reaching the state s2
% a:  the last executed action
% tab: the current Qtable
% alpha: learning rate
% gamma: discount factor
% Q: the resulting Qtable


rul = zeros(size(Q,1),size(Q,2));

Qa = getQvalue(Q(:,a), FV);
Qap = getQvalue(Q(:,ap), FVp);
rul(:,a) = FV;

TD = r + RLparam.gamma*Qap - Qa;
e_trace = e_trace* RLparam.gamma * RLparam.lambda + rul;

Q =  Q + RLparam.fa * RLparam.alpha * ( e_trace*TD);

%
%[Qa2,b,FV2] = efbd(x,Q(:,a),cores);
%[Qa Qa2]
%[FV FV2]
%



