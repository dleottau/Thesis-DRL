function [A, P] = p_source_selection2( RL,FV,conf)
% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

% Syncronizing exploration and transfer between agents
rnd.nash     = ones(1,3);
rnd.nashExpl = ones(1,3);
rnd.expl     = ones(1,3);
rnd.TL       = ones(1,3);

%P = [1 1 1];
Ps=zeros(3,max([conf.nactions_x, conf.nactions_y, conf.nactions_w]));
if conf.sync.nash
    rnd.nash     = rnd.nash*randn();
    rnd.nashExpl = rnd.nashExpl*randn();
else rnd.nash = randn(1,3);
    rnd.nashExpl = randn(1,3);
end
if conf.sync.expl
    rnd.expl = rnd.expl*rand();
else
    rnd.expl = rand(1,3);
end
if conf.sync.TL
    rnd.TL = rnd.TL*rand();
else
    rnd.TL = rand(1,3);
end

V_src          = RL.V_src;
Vr_min         = conf.Vr_min;
Vr_max         = conf.Vr_max;
V_action_steps = conf.V_action_steps;
actionlist     = conf.Actions;

if RL.param.softmax > 0
    [A_target(1), Ps(1,1:conf.nactions_x)] = softmax_selectionRBF(RL.Q     , FV , RL.param , RL.T);
    [A_target(2), Ps(2,1:conf.nactions_y)] = softmax_selectionRBF(RL.Qy    , FV , RL.param , RL.T_y);
    [A_target(3), Ps(3,1:conf.nactions_w)] = softmax_selectionRBF(RL.Q_rot , FV , RL.param , RL.T_rot);
    P=Ps(A_target);
else
    aux=RL.param.softmax;
    RL.param.softmax = 1;
    [A_target(1), Ps(1,1:conf.nactions_x)] = softmax_selectionRBF(RL.Q     , FV , RL.param , RL.T);
    [A_target(2), Ps(2,1:conf.nactions_y)] = softmax_selectionRBF(RL.Qy    , FV , RL.param , RL.T_y);
    [A_target(3), Ps(3,1:conf.nactions_w)] = softmax_selectionRBF(RL.Q_rot , FV , RL.param , RL.T_rot);
    RL.param.softmax=aux;
    A_target(1) = e_greedy_selection(RL.Q, FV, RL.param.epsilon);
    A_target(2) = e_greedy_selection(RL.Qy, FV, RL.param.epsilon);
    A_target(3) = e_greedy_selection(RL.Q_rot, FV, RL.param.epsilon);            
    P=Ps(A_target);
end

% Transfer knowledge
if conf.TRANSFER && conf.nash 
if RL.param.aScale<100        
    V_tgt(1) = actionlist.x(GetBestAction(RL.Q,FV));
    V_tgt(2) = actionlist.y(GetBestAction(RL.Qy,FV));
    V_tgt(3) = actionlist.w(GetBestAction(RL.Q_rot,FV));
        
    if conf.nash == 2
        V_src(1) = triang_dist(Vr_min(1),V_src(1),Vr_max(1),1-RL.param.p,RL.param.aScale);
        V_src(2) = triang_dist(Vr_min(2),V_src(2),Vr_max(2),1-RL.param.p,RL.param.aScale);
        V_src(3) = triang_dist(Vr_min(3),V_src(3),Vr_max(3),1-RL.param.p,RL.param.aScale);
        
        V_tgt(1) = triang_dist(Vr_min(1),V_tgt(1),Vr_max(1),RL.param.p,RL.param.aScale);
        V_tgt(2) = triang_dist(Vr_min(2),V_tgt(2),Vr_max(2),RL.param.p,RL.param.aScale);
        V_tgt(3) = triang_dist(Vr_min(3),V_tgt(3),Vr_max(3),RL.param.p,RL.param.aScale);
    else
        V_src = V_src + ((Vr_max-Vr_min)/RL.param.aScale).*rnd.nash*(1 - RL.param.p);
        V_tgt = V_tgt + ((Vr_max-Vr_min)/RL.param.aScale).*rnd.nash*(RL.param.p);
    end
    
    V_tgt       = clipDLF( V_tgt,Vr_min,Vr_max);
    A_target(1) = 1 + round(V_tgt(1)/V_action_steps(1));
    A_target(2) = 1 + round(V_tgt(2)/V_action_steps(2) + Vr_max(2)/V_action_steps(2));
    A_target(3) = 1 + round(V_tgt(3)/V_action_steps(3) + Vr_max(3)/V_action_steps(3));
else
    V_src = V_src + ((Vr_max-Vr_min)/(RL.param.aScale-100)).*rnd.nash*(1 - RL.param.p);
end
end

V_src    = clipDLF( V_src,Vr_min,Vr_max);
A_src(1) = 1 + round(V_src(1)/V_action_steps(1));
A_src(2) = 1 + round(V_src(2)/V_action_steps(2) + Vr_max(2)/V_action_steps(2));
A_src(3) = 1 + round(V_src(3)/V_action_steps(3) + Vr_max(3)/V_action_steps(3));

if (rnd.TL >= RL.param.p)
    A = A_target;
else
    A = A_src;
end

%