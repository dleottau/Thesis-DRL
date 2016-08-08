function getPolicy()

clear all
close all
clc

%load finalTests/DRL_25Runs_Noise0.1_MA2_alpha0.1_lambda0.9_k1.5_beta0.9_softmax70_decay6.mat
load finalTests/DRL_29Runs_Noise0.1_MA1_alpha0.2_lambda0.7_softmax11_decay7.mat

conf.Voffset = 1; %Offset Speed in mm/s
conf.V_action_steps = [25, 20, 20]/4; % /4 works good
conf.Vr_max = [100 40 40]; %x,y,rot Max Speed achieved by the robot
conf.Vr_min = -conf.Vr_max;
conf.Vr_min(1) = conf.Voffset;
conf.feature_step = [50, 10, 10];
conf.feature_min = [0, -40, -40]; 
conf.feature_max = [600, 40, 40]; 
actionlist  = ActionTable( conf.Vr_min, conf.V_action_steps, conf.Vr_max, conf.Voffset ); % the table of actions
conf.nactions    = size(actionlist,1);

[vx, ax]=max(results.Qx_best,[],2);
[vy, ay]=max(results.Qy_best,[],2);
[vw, aw]=max(results.Qw_best,[],2);

for i=1:length(vx)
    ax(i) = actionlist(ax(i),1);    
    ay(i) = actionlist(ay(i),2);    
    aw(i) = actionlist(aw(i),3);
    if vx(i)==0, ax(i)=777; end; 
    if vy(i)==0, ay(i)=777; end;
    if vw(i)==0, aw(i)=777; end;
end;
 
Vpi=[ax ay aw]'
save ('dribblingPolicy', 'Vpi')
    
    