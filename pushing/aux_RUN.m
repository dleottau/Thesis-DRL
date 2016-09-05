%=========TESTS=============
clear all
clc
clf
close all

conf.Test=1;
sfolder = 'final/'; % Source folder
folder = 'tests/'; % To record the test result

% Just uncomment file (policy) to use

%stringName = 'DRL0; lambda0.9; alpha0.5; softmax2; decay7; 25RUNS.mat'; 
%conf.DRL = 0; conf.fuzzQ = 0; conf.MAapproach = 0; conf.jointState = 1;

%stringName = 'MAapproach0; DRL1; lambda0.9; softmax1; alpha0.3; decay10; beta0.7; k-leninet1; 25RUNS.mat'
%conf.DRL = 1; conf.fuzzQ = 0; conf.MAapproach = 0; conf.jointState = 1;

stringName = 'fuz-DRL1; lambda0.95; softmax1.1; decay9; alpha0.3; Nactions3; 25RUNS.mat';
conf.DRL = 1; conf.fuzzQ = 1; conf.MAapproach = 0; conf.jointState = 1;


%% **** These were for my thesis, just ignore them
%stringName = 'MAapproach1; DRL1; lambda0.95; alpha0.4; softmax1.1; decay10; 25RUNS.mat';
%conf.DRL = 1; conf.fuzzQ = 0; conf.MAapproach = 0; conf.jointState = 1;

%stringName = 'MAapproach2; DRL1; lambda0.95; softmax2; alpha0.3; decay8; beta0.7; k-leninet1; 25RUNS_k1_beta0.7.mat';
%conf.DRL = 1; conf.fuzzQ = 0; conf.MAapproach = 0; conf.jointState = 1;
%% ********

conf.DRAWS = 1;
conf.record = 1;
RUNS=1;

if conf.Test % Performance tests
    %load loadFile;
    results=importdata([sfolder stringName]);
    RL.Q_rot    = 0;
    if conf.DRL
        RL.Q_rot    = results.Qok_rot;
    end
    RL.Q        = results.Qok_x;
    clear results;
end


global opti;
opti=0;
conf.opti=opti;

conf.episodes = 1000;   % maximum number of  episode
conf.Ts = 0.2; %Sample time of a RL step
conf.maxDistance = 800;    % maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.Runs = RUNS;
conf.NOISE = 0.01;

conf.Q_INIT = 0;
conf.EXPL_EPISODES_FACTOR = 10;
RL.param.alpha       = 0.4;   % learning rate
RL.param.gamma       = 0.99;   % discount factor
RL.param.lambda      = 0.9;   % the decaying elegibiliy trace parameter
RL.param.epsilon = 1;
RL.param.softmax = 1;


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
    conf.Nactios = [3,3];
end
conf.V_action_steps = (conf.Vr_max-conf.Vr_min)./(conf.Nactios-[1 1]);
conf.Vr_min(1) = 0;
conf.feature_step = [200, 30, 30 conf.V_action_steps(2)]; %[50, 10, 10]  %states
conf.feature_min = [0, -45, -45 conf.Vr_min(2)];
conf.feature_max = [800, 45, 45 conf.Vr_max(2)];

conf.fileName = stringName;


%parfor n=1:RUNS
for n=1:RUNS
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
        if conf.DRL
            results.Qok_rot = Qw{i};
        end
    end
end

results.performance(2,3)=pf_min;
results.performance(1,3)=mean(pf);
results.performance(3,3)=pf_max;
results.performance(4,3)=mean(pf_sd);

f=mean(pf) % Fitness function: percentage of goals scored 

results.mean_goals = mean(pscored,2);
results.std_goals = std(pscored,0,2);

if conf.DRAWS==1
     figure,plot(mean(pscored,2))
     if conf.record > 0
            saveas(gcf,[folder stringName '.fig'])
     end
end

if conf.Test
   stringName=['Test-' stringName]; 
end    
if conf.record > 0
   save ([folder stringName], 'results');
end
    
% end
% 
% toc

