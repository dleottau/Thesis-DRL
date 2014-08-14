function [ Q,Qt,trace] = UpdateSARSAlambda( s, a, r, sp, ap, Q,Qs,Qt, alpha, gamma, lambda, trace)
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


    delta  =   r + gamma * Q(sp,ap)  - Q(s,a);
    
    % Replacing traces
    trace(s,a) = 1.0;   
    
    %control traces
    %trace(s,:) = 0.0;  %optional trace reset
    %trace(s,a) = 1.0 + gamma * lambda + trace(s,a);  
    
    %Eligibility traces
    %trace(s,a) = 1 + trace(s,a);

    %-----------------------------
    Q = Q + alpha * delta * trace;
    trace = gamma * lambda * trace;
        
    %Q value reuse
    %maxQ=max(max(Qt));
    %minQ=min(min(Qt));
    %Qs = Qs/max(abs(minQ),abs(maxQ)); %tabla Q normalizada entre Rmin y Rmax
    %Qs = 5*Qs/abs(max(max(Qs))); %tabla Q normalizada a Rmax

    %Qt = Qt + alpha * delta * trace;
    %trace = gamma * lambda * trace;
    %Q = Qs + Qt;
    
end

%F=6500 con PonderadorQ=1, no converge.
%F=1900 con PonderadorQ=2
%F=1856 con PonderadorQ=3
%F=1689 con PonderadorQ=5

