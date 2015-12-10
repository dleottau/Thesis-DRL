function [ Q, T] = UpdateSARSA( s, a, r, sp, ap, tab , param, T )
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

Q = tab;

if param.MAapproach == 2
    T(s,a)=T(s,a)*param.beta;
end

delta = r + param.gamma*Q(sp,ap) - Q(s,a);

if param.MAapproach == 0 || param.MAapproach == 1 || (param.MAapproach == 2 && ( delta>0 || rand()>1-exp(-param.k*T(s,a)))) 
    Q(s,a) =  Q(s,a) + param.pcoop*param.alpha * delta;
    %Q(s,a) =  Q(s,a) + param.alpha * ( r + param.gamma*Q(sp,ap) - Q(s,a) );
end