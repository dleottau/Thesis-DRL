function [ a ] = softmax_selection( Q , s, tempdec )
% softmax_selection selects an action using the Gibs distribution and softmax strategy
% Q: the Qtable
% s: the current state
% temperature: ponderation 


actions = size(Q,2);

Qstate=Q(s,:)
s
%temp = tempdec*abs(max(Q(s,:)))
temp=tempdec

if temp==0
    temp=realmin;
end

v_qa = exp( Q(s,:)/temp );
sum_qa = sum( exp( Q(s,:)/temp ) );
if sum_qa==0
    sum_qa=realmin;
end
Ps = v_qa/sum_qa
if sum(Ps)==0
    Ps=Ps+1/actions;
end
a = find(rand <= cumsum(Ps),1)
a;

