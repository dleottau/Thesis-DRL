function [ Actions ] = ActionTable (V_action_steps)
%ActionTable

%actions for the Dribbling
Ax = 0:V_action_steps(1):100;
Ay = -50:V_action_steps(2):50;

% Ojo, por ahora Ax y Ay deben tener el mismo numero de acciones

Actions(:,1) = Ax';
Actions(:,2) = Ay';


