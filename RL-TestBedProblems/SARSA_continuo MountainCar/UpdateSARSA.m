function [ Q e_trace] = UpdateSARSA( FV, a, r, FVp, ap, Q, e_trace , param)
                                      
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

%Q=Qi;

rul = zeros(size(Q,1),size(Q,2));

Qa = getQvalue(Q(:,a), FV);
Qap = getQvalue(Q(:,ap), FVp);
rul(:,a) = FV;

TD = r + param.gamma*Qap - Qa;
e_trace = e_trace* param.gamma * param.lambda + rul;

Q =  Q + param.fa*param.alpha * ( e_trace*TD);

if isnan(sum(sum(Q)))
    a;
end