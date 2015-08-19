function [a, p] = action_selection(Q, FV, param)
    
%p=1;
if param.softmax > 0
    [a, p] = softmax_selectionRBF(Q, FV, param.softmax);
else
    [a, p] = softmax_selectionRBF(Q, FV, 1);
    [a, p] = e_greedy_selection(RL.Q, FV, param.epsilon);
end