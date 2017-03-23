function [a, p] = p_source_selection_FLC( Q, T, FV , RLparam, a_source, sync, rnd)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

% --------------------------
N  = size(Q,2); % number of actions
% --------------------------

if sync.expl <= 0
    rnd.expl = rand();
end
if sync.TL <= 0
    rnd.TL = rand();
end

[a_target, p] = softmax_selectionRBF(Q, FV, RLparam.softmax, T, RLparam.k);    % Revisar los parámetros de la función!
if RLparam.softmax <= 0     
    a_target = e_greedy_selection(Q, FV, RLparam.epsilon);          % Revisar los parámetros de la función!
end

if (rnd.TL >= RLparam.p)        % ¿De dónde se saca el RLparam.p?
    a = a_target;
else
    a = a_source;
end

%p = P(a);
%p = p - ( (N*p-1)/(N*(1-N)) + 1/N );