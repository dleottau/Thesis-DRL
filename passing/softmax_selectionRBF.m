function [ a, p ] = softmax_selectionRBF( Q , FV, RLparam, T)
% Softmax_selection selects an action using the Gibs distribution and softmax strategy
% Q           : the Qtable
% s           : the current state
% temperature : ponderation

actions = size(Q,2);
Qs      = zeros(1,size(Q,2));

for i = 1:actions;
    Qs(1,i) = getQvalue(Q(:,i), FV);
    if T ~= 0 % if lenient RL
        Ts(1,i) = getQvalue(T(:,i), FV);
    end
end

if T ~= 0
    minTemp = 10E-3 + min(Ts)*RLparam.k;
    v_qa    = exp((Qs-max(Qs))/minTemp);
    sum_qa  = sum(v_qa);
    %     minTemp = (10E-6 + (1-min(Ts)))*2;
    %     v_qa = exp( (Qs-max(Qs))*minTemp);
    %     sum_qa = sum( exp((Qs-max(Qs))*minTemp) );
else
    temp   = 10E-12+RLparam.softmax;
    v_qa   = exp( (Qs-max(Qs))/temp );
    sum_qa = sum( exp( (Qs-max(Qs))/temp ));
end

if sum_qa == 0
    sum_qa = 10E-12;
end

Ps = v_qa/sum_qa;

if sum(Ps) == 0
    Ps = Ps+1/actions;
end

a = find(rand <= cumsum(Ps),1);
p = Ps(a);

if isempty(a)
    Ps
    keyboard
end


% actions = size(Q,2);
% Qs      = zeros(1,size(Q,2));
%
% for i = 1:actions;
%     Qs(1,i) = getQvalue(Q(:,i), FV);
% end
%
% temp   = 10E-6+tempdec;
% v_qa   = exp( (Qs-max(Qs))/temp );
% sum_qa = sum( exp( (Qs-max(Qs))/temp ));
%
% if sum_qa == 0
%     sum_qa = 10E-6;
% end
%
% Ps = v_qa/sum_qa;
%
% if sum(Ps) == 0
%     Ps = Ps+1/actions;
% end
% a = find(rand <= cumsum(Ps),1);
% p = Ps(a);
%
% if isempty(a)
%     Ps
% end