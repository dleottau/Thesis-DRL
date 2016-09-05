function [ Q, e_trace] = UpdateSARSA( FV, a, r, FVp, ap, Q, e_trace, RLparam, T, MAapproach)

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

FVT      = zeros(size(Q,1),size(Q,2));
Qa       = getQvalue(Q(:,a), FV);
Qap      = getQvalue(Q(:,ap), FVp);
FVT(:,a) = FV;

if MAapproach == 2
    Ta     = getQvalue(T(:,a), FV);
    T(:,a) = T(:,a) + (Ta*RLparam.beta - Ta)*FV;
    T(:,a) = clipDLF(T(:,a),0,1);
    % OJO: quizas necesario vover a calcular Ta o multiplicarlo por beta
end

TD = r + RLparam.gamma*Qap - Qa;

if MAapproach == 0 || MAapproach == 1 || MAapproach == 3 || MAapproach == 2 && ( TD>0 || rand()>1-exp(-RLparam.k*Ta))
    e_trace = e_trace* RLparam.gamma * RLparam.lambda + FVT;
    Q       =  Q + RLparam.fa * RLparam.alpha * ( e_trace*TD);
end

% rul      = zeros(size(Q,1),size(Q,2));
% Qa       = getQvalue(Q(:,a), FV);
% Qap      = getQvalue(Q(:,ap), FVp);
% rul(:,a) = FV;
%
% TD      = r + RLparam.gamma*Qap - Qa;
% e_trace = e_trace* RLparam.gamma * RLparam.lambda + rul;
% Q       =  Q + RLparam.fa * RLparam.alpha * ( e_trace*TD);