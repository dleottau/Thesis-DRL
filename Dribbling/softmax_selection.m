function [ a, Ps ] = softmax_selection( Qs,T,s,RLparam,rnd )
% softmax_selection selects an action using the Gibs distribution and softmax strategy
% Q: the Qtable
% s: the current state
% temperature: ponderation 


actions = size(Qs);

%Qs=Q(s,:);

if T ~= 0 && RLparam.softmax > 0
    Ts=T(s,:);
    minTemp = (10E-6 + (1-min(Ts)))*RLparam.k;
    v_qa = exp( (Qs-max(Qs))*minTemp);
    sum_qa = sum( exp((Qs-max(Qs))*minTemp) );
elseif RLparam.softmax > 0
    temp = 1 + RLparam.softmax;
    v_qa = exp( (Qs-max(Qs))/temp );
    sum_qa = sum( exp( (Qs-max(Qs))/temp ));
else
    temp = 1;
    v_qa = exp( (Qs-max(Qs))/temp );
    sum_qa = sum( exp( (Qs-max(Qs))/temp ));
end

if sum_qa==0
    sum_qa=realmin;
end
Ps = v_qa/sum_qa;
if sum(Ps)==0
    Ps=Ps+1/actions;
end
a = find(rnd <= cumsum(Ps),1);
p = Ps(a);

if isempty(a)
    a
end


