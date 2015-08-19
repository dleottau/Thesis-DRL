function [ a, p ] = softmax_selectionRBF( Q , FV, tempdec )
% softmax_selection selects an action using the Gibs distribution and softmax strategy
% Q: the Qtable
% s: the current state
% temperature: ponderation 

actions = size(Q,2);

Qs=zeros(1,size(Q,2));
for i=1:actions;
    Qs(1,i) = getQvalue(Q(:,i), FV);
end

%temp = tempdec*abs(max(Q(s,:)))
%temp=1+tempdec;
temp=10E-6+tempdec;

if temp<=0
    temp=realmin;
end

v_qa = exp( (Qs-max(Qs))/temp );
sum_qa = sum( exp( (Qs-max(Qs))/temp ));
%v_qa = exp( (Qs)/temp );
%sum_qa = sum( exp( (Qs)/temp ));


if sum_qa==0
    sum_qa=10E-6;
end
Ps = v_qa/sum_qa;
if sum(Ps)==0
    Ps=Ps+1/actions;
end
a = find(rand <= cumsum(Ps),1);
p = Ps(a);





