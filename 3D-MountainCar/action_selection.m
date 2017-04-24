function [a, p] = action_selection(Q, FV, param, T)
    
%p=1;
if param.softmax > 0
    [a, p] = softmax_selectionRBF(Q, FV, param.softmax,T);
else
    [a, p] = softmax_selectionRBF(Q, FV, param.softmaxCA, T);
    a = e_greedy_selection(Q, FV, param.epsilon);
end