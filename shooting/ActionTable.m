function [ Actions ] = ActionTable ( conf )
% ActionTable

% Actions for the Dribbling
Ax = conf.Vr_min(1) : conf.V_action_steps(1) : conf.Vr_max(1);
% -------------------------------------------------------------------------
Ay = conf.Vr_min(2) : conf.V_action_steps(2) : conf.Vr_max(2);
% -------------------------------------------------------------------------
Aw = conf.Vr_min(3) : conf.V_action_steps(3) : conf.Vr_max(3);
% -------------------------------------------------------------------------

Actions.x = Ax';
% -------------------------------------------------------------------------
Actions.y = Ay';
% -------------------------------------------------------------------------
Actions.w = Aw';

ct = 1;
for i = 1:length(Ax)
    % ---------------------------------------------------------------------
    for k = 1:length(Ay)
    % ---------------------------------------------------------------------
        for j = 1:length(Aw)           
            Actions.cent(ct,:) = [Ax(i) Ay(k) Aw(j)];
            ct                 = ct+1;
        end
    end
end