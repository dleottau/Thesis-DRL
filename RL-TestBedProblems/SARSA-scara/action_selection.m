function [a, p]   = action_selection(Q, s, param, T)

if param.MAapproach == 0
    p=1;
    a  = e_greedy_selection( Q , s, param.epsilon );
else
    [~, p] = softmax_selection(Q, s, param, T);
    a  = e_greedy_selection( Q , s, param.epsilon );
end


