function [ Q, trace, T] = UpdateSARSAlambda( s, a, r, sp, ap, Q, RLparam, trace, MAapproach, fa, T)
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
% deco = 1000;
% M = floor(QM(s,a)/deco);
% rp = rem(QM(s,a),deco)-500;
% if r>rp
%   rp = r;
% end
% M=M+1;
% QM(s,a) = deco*(M)+500+ rp;
% 
% % =======
% 
% if M > RLparam.M        % For leniency 

%    r=rp;
%    QM(s,a)=QM(s,a)-deco;
    

    T(s,a)=T(s,a)*RLparam.beta;

    delta  =   r + RLparam.gamma * Q(sp,ap)  - Q(s,a);
        
    % Replacing traces
    trace(s,a) = 1.0;   
    %control traces
    %trace(s,:) = 0.0;  %optional trace reset
    %trace(s,a) = 1.0 + gamma * lambda + trace(s,a);  
    %Eligibility traces
    %trace(s,a) = 1 + trace(s,a);
    
    if MAapproach == 0 || MAapproach == -1 && delta > 0 || MAapproach == 1 && ( delta>0 || rand()>1-exp(-RLparam.k*T(s,a)) ) 
        Q = Q + fa*RLparam.alpha * delta * trace;
        trace = RLparam.gamma * RLparam.lambda * trace;
    end
        
end
