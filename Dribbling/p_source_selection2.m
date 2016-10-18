function [A, P] = p_source_selection2( RL,s,conf)

% source_action_selection selects an action using p probability
% Q: the Qtable
% s: the current state
% epsilon
% at transferred action
% p probability for choosing transferred action

% Syncronizing exploration and transfer between agents
rnd.nash=ones(1,3);
rnd.nashExpl=ones(1,3);
rnd.expl=ones(1,3);
rnd.TL=ones(1,3);
if conf.sync.nash, rnd.nash=rnd.nash*randn(); rnd.nashExpl=rnd.nashExpl*randn(); else rnd.nash=randn(1,3); rnd.nashExpl=randn(1,3); end  
if conf.sync.expl, rnd.expl=rnd.expl*rand(); else rnd.expl=rand(1,3); end
if conf.sync.TL, rnd.TL=rnd.TL*rand(); else rnd.TL=rand(1,3); end

N(1) = size(RL.Q,2); % number of actions x
Qs(1,:)=RL.Q(s,:);
N(2) = size(RL.Q_y,2); % number of actions y
Qs(2,:)=RL.Q_y(s,:);
N(3) = size(RL.Q_rot,2); % number of actions w
Qs(3,:)=RL.Q_rot(s,:);

V_src=RL.V_src;
Vr_min=conf.Vr_min;
Vr_max=conf.Vr_max;
V_action_steps=conf.V_action_steps;
actionlist = conf.Actions;

[A_target(1), P(1,:)] = softmax_selection(Qs(1,:), RL.T, s, RL.param, rnd.expl(1));
[A_target(2), P(2,:)] = softmax_selection(Qs(2,:), RL.T_y, s, RL.param, rnd.expl(2));
[A_target(3), P(3,:)] = softmax_selection(Qs(3,:), RL.T_rot, s, RL.param, rnd.expl(3));
if RL.param.softmax < 0
    A_target(1) = e_greedy_selection(RL.Q, s, RL.param.epsilon, rnd.expl(1));
    A_target(2) = e_greedy_selection(RL.Q_y, s, RL.param.epsilon, rnd.expl(2));
    A_target(3) = e_greedy_selection(RL.Q_rot, s, RL.param.epsilon, rnd.expl(3));
end


% Transfer knowledge
if conf.TRANSFER && conf.nash
    V_tgt(1) = actionlist(GetBestAction(RL.Q,s),1);    
    V_tgt(2) = actionlist(GetBestAction(RL.Q_y,s),2);    
    V_tgt(3) = actionlist(GetBestAction(RL.Q_rot,s),3);
    
    if conf.nash==2
        V_src(1)=triang_dist(Vr_min(1),V_src(1),Vr_max(1),1-RL.param.p,RL.param.aScale);
        V_src(2)=triang_dist(Vr_min(2),V_src(2),Vr_max(2),1-RL.param.p,RL.param.aScale);
        V_src(3)=triang_dist(Vr_min(3),V_src(3),Vr_max(3),1-RL.param.p,RL.param.aScale);
        V_tgt(1)=triang_dist(Vr_min(1),V_tgt(1),Vr_max(1),RL.param.p,RL.param.aScale);
        V_tgt(2)=triang_dist(Vr_min(2),V_tgt(2),Vr_max(2),RL.param.p,RL.param.aScale);
        V_tgt(3)=triang_dist(Vr_min(3),V_tgt(3),Vr_max(3),RL.param.p,RL.param.aScale);
    else
        V_src = V_src + ((Vr_max-Vr_min)/RL.param.aScale).*rnd.nash*(1 - RL.param.p);
        V_tgt = V_tgt + ((Vr_max-Vr_min)/RL.param.aScale).*rnd.nash*(RL.param.p);
    end
    V_tgt = clipDLF( V_tgt,Vr_min,Vr_max);
    A_target(1) = 1 + round(V_tgt(1)/V_action_steps(1));
    A_target(2) = 1 + round(V_tgt(2)/V_action_steps(2)  + Vr_max(2)/V_action_steps(2));
    A_target(3) = 1 + round(V_tgt(3)/V_action_steps(3) + Vr_max(3)/V_action_steps(3));
%     A_target(1) = clipDLF( round(GetBestAction(RL.Q,s) + 1*rnd.nashExpl(1)*RL.param.p), 1, N(1) );
%     A_target(2) = clipDLF( round(GetBestAction(RL.Q_y,s) + 1*rnd.nashExpl(2)*RL.param.p), 1, N(2) );
%     A_target(3) = clipDLF( round(GetBestAction(RL.Q_rot,s) + 1*rnd.nashExpl(3)*RL.param.p), 1, N(3) );
end

V_src = clipDLF( V_src,Vr_min,Vr_max);
A_src(1) = 1 + round(V_src(1)/V_action_steps(1));  
A_src(2) = 1 + round(V_src(2)/V_action_steps(2)  + Vr_max(2)/V_action_steps(2));
A_src(3) = 1 + round(V_src(3)/V_action_steps(3) + Vr_max(3)/V_action_steps(3));

if (rnd.TL >= RL.param.p) 
    A = A_target; 
else
    A = A_src;
end

P=[1 1 1];
%p=P(A);
%p = clipDLF( p - ( (N*p-1)/(N*(1-N)) + 1/N ), 0,1);









%neashNDist = normpdf(1:nActions, a_sh, RLparam.aScale*(1 - RLparam.p + 100*realmin));
%RLparam.softmax=0;
%[a_source, ~] = softmax_selection(neashNDist, 0, s, RLparam, rnd.nash);
%a_source = clipDLF( round(a_sh + 2*rnd.nash*(1 - RLparam.p)), 1,nActions );
%a_target = clipDLF( round(GetBestAction(Q,s) + 1*rnd.nashExpl* RLparam.epsilon), 1,nActions );

    




    

    % << Temporal for NeASh adaptive 
%     A_target(1) = GetBestAction(RL.Q,s);
%     A_target(2) = GetBestAction(RL.Q_y,s);
%     A_target(3) = GetBestAction(RL.Q_rot,s);
%     
%     V_target(1) = actionlist(A_target(1),1);    
%     V_target(2) = actionlist(A_target(2),2);    
%     V_target(3) = actionlist(A_target(3),3);    
%     
%     V_target = clipDLF( V_target + ((Vr_max-Vr_min)/RL.param.aScale).*randn(1,3).*(RL.param.Pa), Vr_min, Vr_max);
%     
%     [~, PP(1,:)] = softmax_selection(RL.Q(s,:), 0, s, RL.param, rnd.expl);
%     [~, PP(2,:)] = softmax_selection(RL.Q_y(s,:), 0, s, RL.param, rnd.expl);
%     [~, PP(3,:)] = softmax_selection(RL.Q_rot(s,:), 0, s, RL.param, rnd.expl);
%     
%     A_target(1) = 1 + round(V_target(1)/V_action_steps(1));  
%     A_target(2) = 1 + round(V_target(2)/V_action_steps(2)  + Vr_max(2)/V_action_steps(2));
%     A_target(3) = 1 + round(V_target(3)/V_action_steps(3) + Vr_max(3)/V_action_steps(3));
%       
%     for m=1:3
%         if (rnd.TL >= RL.param.Pa(m)), ap(m) = A_target(m); else ap(m) = A_src(m); end
%     end
%     
%     Pap= [PP(1,ap(1)), PP(2,ap(2)), PP(3,ap(3))];