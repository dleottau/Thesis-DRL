function [ Q, trace] = UpdateSARSAlambda( s, a, r, sp, ap, Q, RLparam, trace, MAapproach)
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


    delta  =   r + RLparam.gamma * Q(sp,ap)  - Q(s,a);
    
    % Replacing traces
    trace(s,a) = 1.0;   
    %control traces
    %trace(s,:) = 0.0;  %optional trace reset
    %trace(s,a) = 1.0 + gamma * lambda + trace(s,a);  
    %Eligibility traces
    %trace(s,a) = 1 + trace(s,a);
    
    if MAapproach == 0 || (MAapproach == -1 && delta > 0) 
        Q = Q + RLparam.alpha * delta * trace;
    end
        
    trace = RLparam.gamma * RLparam.lambda * trace;
    
    
    
    
    
end
