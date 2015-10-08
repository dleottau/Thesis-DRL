function f = RUN_SCRIPT(x,RUNS,stringName)
conf.Test=0;

folder = 'final/';

%  %=========TESTS=============
% clear all
% clc
% clf
% close all
% 
% conf.Test=1;
% folder = ''; 
% stringName= 'DRL0; lambda0.9; alpha0.5; softmax2.1; decay5; 6RUNS.mat';  % Here file name.mat
% loadFile = [folder stringName];
% RUNS=1;% conf.Test=1;

% if conf.Test % Performance tests
%     %load loadFile;
%     results=importdata(loadFile);
%     RL.Q        = results.Qok_x;%Qx_DRL;
%     RL.Q_rot    = results.Qok_rot;%Qrot_DRL;
%     clear results;
% end
% x(1) = 6;   % exploration decay
% x(2) = 0.1;  % epsilon
% x(3) = 0.3;   % learning rate
% x(4) = 0.9;   % lambdaUntitled Folder
% x(5) = 1;  % 0 for CRL, 1 for DRL
% 
% % myCluster = parcluster('local');
% % if matlabpool('size') == 0 % checking to see if my pool is already open
% %     matlabpool(myCluster.NumWorkers)
% % else
% %     matlabpool close
% %     matlabpool(myCluster.NumWorkers)
% % end
% %======================


global flagFirst;
global opti;
conf.opti=opti;


conf.episodes = 1000;   % maximum number of  episode
conf.Ts = 0.2; %Sample time of a RL step
conf.maxDistance = 800;    % maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.Runs = RUNS;
conf.NOISE = 0.01;
conf.DRL = x(6); %Decentralized RL(1) or Centralized RL(0)
conf.DRAWS = 0;
conf.record = 1;
conf.fuzzQ = 1;


conf.Q_INIT = 0;
conf.EXPL_EPISODES_FACTOR = x(3);
RL.param.alpha       = x(2);   % learning rate
RL.param.gamma       = 0.99;   % discount factor
RL.param.lambda      = x(5);   % the decaying elegibiliy trace parameter
RL.param.epsilon = 1;
RL.param.softmax = x(4);

if conf.Test %Para pruebas de performance
    RL.param.epsilon = 0;
    RL.param.softmax = 0;
end 


conf.Pt=[conf.maxDistance/2 0];
conf.posb=[0.5*conf.maxDistance 200];
     

conf.deltaVw = 2;    
conf.Vr_max = [60 5]; %x,y,rot Max Speed achieved by the robot
conf.Vr_min = -conf.Vr_max;
conf.Vr_min(1) = 0;
conf.maxDeltaV = conf.Vr_max.*[1/2 1/2]; %mm/s/Ts
conf.Nactios = [5,5];
if conf.fuzzQ && conf.DRL
    conf.Nactios = [x(1),5];
end
conf.V_action_steps = (conf.Vr_max-conf.Vr_min)./(conf.Nactios-[1 1]);
conf.Vr_min(1) = 0;
conf.feature_step = [200, 30, 30 conf.V_action_steps(2)]; %[50, 10, 10]  %states
conf.feature_min = [0, -45, -45 conf.Vr_min(2)];
conf.feature_max = [800, 45, 45 conf.Vr_max(2)];



a_spot={'r' 'g' 'b' 'c' 'm' 'y' 'k' '--r' '--g' '--b' '--c' };

parfor n=1:RUNS
%for n=1:RUNS
    %[reward(:,:,i), e_time(:,i), Vavg(:,i), scored(:,i),  RL] = Dribbling2d( i, conf, RL);
    [pscored(:,n) scored(:, n) Q{n} Qw{n}] = Dribbling2d( n, conf, RL);
end

pf_min=Inf;
pf_max=-Inf;
interval=0.01;

for i=1:RUNS
        
    pf(i) = mean(scored(ceil(interval*conf.episodes):end,i));
    pf_sd(i) = std(scored(ceil(interval*conf.episodes):end,i));
    if pf(i) < pf_min
        pf_min=pf(i);
    end
    if pf(i) > pf_max
        pf_max=pf(i);
        results.Qok_x = Q{i};
        %if conf.DRL
            results.Qok_rot = Qw{i};
        %end
    end
end

results.performance(2,3)=pf_min;
results.performance(1,3)=mean(pf);
results.performance(3,3)=pf_max;
results.performance(4,3)=mean(pf_sd);

f=mean(pf); % Fitness function: percentage of goals scored 

results.mean_goals = mean(pscored,2);
results.std_goals = std(pscored,0,2);

if conf.fuzzQ
    stringName=['fuz-' stringName];
end

if conf.DRAWS==1
     figure,plot(mean(pscored,2))
     if conf.record > 0
            saveas(gcf,[folder stringName '.fig'])
     end
end

if conf.Test
   stringName=['Test-' loadFile]; 
end    
if conf.record > 0
   save ([folder stringName '.mat'], 'results');
end
    
% end
% 
% toc




