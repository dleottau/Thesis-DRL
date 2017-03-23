% function f = RUN_SCRIPT(x,RUNS,stringName)
% conf.Test=0;
%
% folder = 'opti/';

%=========TESTS=============
clear all
clc
clf
close all

% dbstop in getQvalue.m

conf.Test = 1;
sfolder   = 'Opti/'; % Source folder
folder    = 'tests/'; % To record the test result

% Just uncomment file (policy) to use

% stringName = 'DRL0; lambda0.9; alpha0.5; softmax2; decay7; 25RUNS.mat';
% conf.DRL = 0; conf.fuzzQ = 0; conf.MAapproach = 0;
% stringName = 'DRL1; lambda0.9; alpha0.3; softmax1.1; decay10; 25RUNS.mat';
% conf.DRL = 1; conf.fuzzQ = 0; conf.MAapproach = 0;
% stringName = 'fuz-DRL1; lambda0.95; softmax1.1; decay9; alpha0.3; Nactions3; 25RUNS.mat';
% conf.DRL = 1; conf.fuzzQ = 1; conf.MAapproach = 0;

stringName = 'MAapproach0; DRL1; lambda0.9; var400; gain100000000; alpha0.1; softmax1; decay8; 4RUNS.mat';
conf.DRL   = 1; conf.fuzzQ = 0; conf.MAapproach = 0;

conf.DRAWS  = 1;
conf.record = 1;
RUNS        = 1;

if conf.Test % Performance tests
    %load loadFile;
    results  = importdata([sfolder stringName]);
    RL.Q_rot = 0;
    if conf.DRL
        RL.Q_rot = results.Qok_rot;
        RL.Qy    = results.Qok_y;
    end
    RL.Q = results.Qok_x;
    clear results;
end

global opti;
opti      = 0;
conf.opti = opti;

conf.episodes             = 1000;   % maximum number of  episode
conf.Ts                   = 0.2;    % Sample time of a RL step
conf.maxDistance   = 4000;    % Maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.maxDistance_x = 6000;    % Maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.maxDistance_y = 4000;    % Maximum ball distance permited before to end the episode Y FIELD DIMENSION
conf.Runs          = RUNS;
conf.NOISE         = 0.01;
conf.Q_INIT        = 0;
conf.Fr            = 150;            % Friction coefficient

% Parameters of Robot Initial position
conf.r_int = 700;
conf.r_ext = 1200;
conf.c_ang = 90;   % 135;
% -------------------------------------------------------------------------

RL.param.alpha   = 0.1;   % learning rate
RL.param.gamma   = 0.99;   % discount factor
RL.param.lambda  = 0.9;   % the decaying elegibiliy trace parameter
RL.param.epsilon = 1;
RL.param.softmax = 1;

if conf.Test %Para pruebas de performance
    RL.param.epsilon = 0;
    RL.param.softmax = 0;
end

conf.Pt        = [0 0];          % Target Position
conf.Pb        = [1800 0];
conf.deltaVw   = 2;
conf.Vr_max    = [100 40 40];    % x,y,rot Max Speed achieved by the robot.-
conf.Vr_min    = -conf.Vr_max;
conf.Vr_min(1) = 0;
conf.maxDeltaV = conf.Vr_max .* [1/3 1/3 1/3];    % mm/s/Ts
conf.Nactios   = [12,9,5];

% -------------------------------------------------------------------------

% Parameters of the circle.-
conf.a3  = 1;              
conf.b3  = 1;
conf.r3  = 400;            
% -------------------------------------------------------------------------

% Parameters of Gaussian Distribution.-------------------------------------
% -------------------------------------------------------------------------
conf.Rgain = 1e8;
Rvar       = 400;

mu         = [conf.Pt(1)  conf.Pt(2)];
sigma      = [Rvar^2 0 ; 0 Rvar^2];
conf.f_gmm = @(x,y)mvnpdf([x y],mu,sigma);
conf.EXPL_EPISODES_FACTOR = 8;
% -------------------------------------------------------------------------

if conf.fuzzQ && conf.DRL
    conf.Nactios = [15,11,7];
end

conf.V_action_steps = (conf.Vr_max-conf.Vr_min)./(conf.Nactios-[1 1 1]);
conf.Vr_min(1)      = 0;
conf.feature_step   = [200, 30, 30 600];
conf.feature_min    = [0, -45, -45 0];
conf.feature_max    = [conf.maxDistance_x, 45, 45 conf.Pb(1)];
% -------------------------------------------------------------------------

a_spot = {'r' 'g' 'b' 'c' 'm' 'y' 'k' '--r' '--g' '--b' '--c' };

% parfor n=1:RUNS
for n = 1:RUNS
    [pscored(:,n) scored(:, n) Q{n} Qy{n} Qw{n}] = Dribbling2d( n, conf, RL );
end

pf_min   = Inf;
pf_max   = -Inf;
interval = 0.01;

for i = 1:RUNS
    pf(i)    = mean(scored(ceil(interval*conf.episodes):end,i));
    pf_sd(i) = std(scored(ceil(interval*conf.episodes):end,i));
    
    if pf(i) < pf_min
        pf_min = pf(i);
    end
    
    if pf(i) > pf_max
        pf_max        = pf(i);
        results.Qok_x = Q{i};
        results.Qok_y = Qy{i};
        % if conf.DRL
        results.Qok_rot = Qw{i};
        % end
    end
end
% -------------------------------------------------------------------------

results.performance(2,3) = pf_min;
results.performance(1,3) = mean(pf);
results.performance(3,3) = pf_max;
results.performance(4,3) = mean(pf_sd);

f = mean(pf) % Fitness function: percentage of goals scored

results.mean_goals = mean(pscored,2);
results.std_goals  = std(pscored,0,2);

% -------------------------------------------------------------------------

if conf.fuzzQ
    stringName=['fuz-' stringName];
end

if conf.DRAWS == 1
    figure,plot(mean(pscored,2))
    grid
    if conf.record > 0
        saveas(gcf,[folder stringName '.fig'])
    end
end

if conf.Test
    stringName = ['Test-' stringName];
end
if conf.record > 0
    save ([folder stringName], 'results');
end