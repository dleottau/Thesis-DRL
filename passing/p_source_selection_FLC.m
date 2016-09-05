function [a, p] = p_source_selection_FLC( Q, T, FV , RLparam, a_sh, nash, sync, rnd)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

if sync.nash <= 0
    rnd.nash     = randn();
    rnd.nashExpl = randn();
end
if sync.expl <= 0
    rnd.expl = rand();
end
if sync.TL <= 0
    rnd.TL = rand();
end

actions = size(Q,2);

if nash == 1      % if nearby action sharing
    a_source      = clipDLF( round(a_sh + 2*rnd.nash*(1 - RLparam.p)), 1,actions );    
    [a_target, p] = softmax_selectionRBF(Q, FV, RLparam.softmax, T);    % (Revisar softmax_selectionRBF)!
else
    a_source      = a_sh;    
    [a_target, p] = softmax_selectionRBF(Q, FV, RLparam.softmax, T);
    
    if RLparam.softmax <= 0     % (alguna vez es negativo)?         
        a_target = e_greedy_selection(Q, FV, RLparam.epsilon);      % Cuidado con esto (revisar)!!!!
    end
end

if (rnd.TL >= RLparam.p)        % ¿De dónde se saca el RLparam.p?
    a = a_target;
else
    a = a_source;
end