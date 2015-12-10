function [a, p] = softmax_selection(Q, s, param, T)

actions = size(Q,2);

Qs=Q(s,:);

if param.MAapproach == 1 && param.epsilon >= 0
    %temp = 1;
    temp = 0.1 + param.k;
    v_qa = exp( (Qs-max(Qs))/temp );
    sum_qa = sum( exp( (Qs-max(Qs))/temp ));
elseif param.MAapproach == 2
    Ts = T(s,:);
    minTemp = (10E-6 + (1-min(Ts)))*param.k;
    v_qa = exp( (Qs-max(Qs))*minTemp);
    sum_qa = sum( exp((Qs-max(Qs))*minTemp) );
else
    temp = 0.1 + param.softmax;
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
a = find(rand() <= cumsum(Ps),1);
p = Ps(a);

