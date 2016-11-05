function [a, p] = action_selection(Q, T, FV, param, xw)

p=1;
if param.softmax(xw) > 0
    [a, p] = softmax_selectionRBF(Q, FV, param.softmax(xw), T);
else
    %[a, p] = softmax_selectionRBF(Q, FV, 1);
    a = e_greedy_selection(Q, FV, param.epsilon);
end