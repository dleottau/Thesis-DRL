function [ a, p ] = softmax_selection( Q,T,s,rnd )
% softmax_selection selects an action using the Gibs distribution and softmax strategy
% Q: the Qtable
% s: the current state
% temperature: ponderation 


actions = size(Q,2);

Qs=Q(s,:);
Ts=T(s,:);

minTemp = 10E-6 + min(Ts);

v_qa = exp(Qs/minTemp);
sum_qa = sum( exp(Qs/minTemp));

if sum_qa==0
    sum_qa=realmin;
end
Ps = v_qa/sum_qa;
if sum(Ps)==0
    Ps=Ps+1/actions;
end
a = find(rnd <= cumsum(Ps),1);
p = Ps(a);

if ~isscalar(a)
    a
end


