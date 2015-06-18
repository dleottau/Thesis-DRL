function [ a, p ] = softmax_selection( Q , s, tempdec, rnd )
% softmax_selection selects an action using the Gibs distribution and softmax strategy
% Q: the Qtable
% s: the current state
% temperature: ponderation 


actions = size(Q,2);
Qs=Q(s,:);

%Qstate=Q(s,:);

%temp = tempdec*abs(max(Q(s,:)))
temp=1+tempdec;

if temp<=0
    temp=realmin;
end

v_qa = exp( (Qs-max(Qs))/temp );
sum_qa = sum( exp( (Qs-max(Qs))/temp ));

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


