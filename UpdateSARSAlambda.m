function [ Q, trace, QM] = UpdateSARSAlambda( s, a, r, sp, ap, Q, RLparam, trace, MAapproach, fa, QM)
% UpdateQ update de Qtable and return it using SARSA
% s1: previous state before taking action (a)
% s2: current state after action (a)
% r: reward received from the environment after taking action (a) in state
%                                             s1 and reaching the state s2
% a:  the last executed action
% Q: the current Qtable
% alpha: learning rate
% gamma: discount factor
% lambda: eligibility trace decay factor
% trace : eligibility trace vector

% For leniency
    
    QM(s,a) = QM(s,a)*RLparam.delta; 
    
    if ( Q(s,a)<=r || rand < 10E-2+RLparam.beta^(-RLparam.alpha*QM(s,a)) )
        
        Q(s,a) = RLparam.lambda*Q(s,a) + (1-RLparam.lambda)*r;
    end
    
end