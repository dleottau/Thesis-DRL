function f = RUN_SCRIPT(x,RUNS,stringName)

conf.Test = 0;
folder    = 'Opti/';

global flagFirst;
global opti;
conf.opti = opti;

%% Parameters.-------------------------------------------------------------
conf.episodes      = 1500;   % Maximum number of episodes
conf.Ts            = 0.2;    % Sample time of a RL step
conf.maxDistance   = 4000;   % Max ball distance permited before to end the episode X FIELD DIMENSION
conf.maxDistance_x = 6000;   % Max ball distance permited before to end the episode X FIELD DIMENSION
conf.maxDistance_y = 4000;   % Max ball distance permited before to end the episode Y FIELD DIMENSION
conf.Runs          = RUNS;   % # of runs
conf.NOISE         = 0.01;   % Noise 0-1
conf.DRL           = 1;      % Decentralized RL(1) or Centralized RL(0)
conf.DRAWS         = 0;      % On-line plot.-
conf.DRAWS1        = 1;      % Enable disable graphics
conf.record        = 1;      % To record logs
conf.fuzzQ         = 0;      % Enables fuzzy Q learning algorithm
conf.Q_INIT        = 0;      % Q table initial values
conf.MAapproach    = x(6);   % 0 no cordination, 1 frequency adjusted, 2 leninet
conf.TRANSFER      = x(8);   % =1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies
conf.nash          = x(9);   % 0 COntrol sharing, 1 NASh
conf.Mtimes        = 0;      % State-action pair must be visited M times before Q being updated

% -------------------------------------------------------------------------
conf.deltaVw   = 2;
conf.Vr_max    = [100 40 40];    % x,y,rot Max Speed achieved by the robot.-
conf.Vr_min    = -conf.Vr_max;
conf.Vr_min(1) = 0;
conf.Fr        = 150;            % Friction coefficient
% -------------------------------------------------------------------------
conf.maxDeltaV = conf.Vr_max .* [1/3 1/3 1/3];    % mm/s/Ts
conf.Nactios   = [16,15,8];
% -------------------------------------------------------------------------
if conf.fuzzQ && conf.DRL
    conf.Nactios = [16,15,8];
end
% -------------------------------------------------------------------------
conf.sync.nash      = 0;
conf.sync.TL        = 0;
conf.sync.expl      = 0;

if conf.TRANSFER
    conf.sync.expl = 1; 
end
if conf.TRANSFER < 0
    conf.episodes = 100;
end
% -------------------------------------------------------------------------
if conf.opti
    conf.DRAWS  = 0;
    conf.record = 1;
end
% -------------------------------------------------------------------------
conf.cE = 1;    % Counter of episodes.-
% -------------------------------------------------------------------------

%% RL parameters.----------------------------------------------------------
RL.param.alpha     = x(1);      % Learning rate
RL.param.gamma     = 0.99;      % Discount factor
RL.param.lambda    = x(4);      % The decaying elegibiliy trace parameter
RL.param.epsilon   = 1;
RL.param.softmax   = x(2);
RL.param.k         = x(7);      % 1.5 Lenience parameter
RL.param.beta      = x(5);      % 0.9 Lenience discount factor
RL.param.exp_decay = x(3);      % Exploration decay parameter

if conf.Test                    % Performance tests
    RL.param.epsilon = 0;
    RL.param.softmax = 0;
end

%% Inwalk-Passing parameters.----------------------------------------------
% Target and ball position.------------------------------------------------
conf.Pt = [0 0];          % Target Position
conf.Pb = [1800 0];       % Initial ball poition
% -------------------------------------------------------------------------

% Parameters of the Robot Initial position.--------------------------------
conf.r_int = 700;
conf.r_ext = 1200;
conf.c_ang = 120;
% -------------------------------------------------------------------------

% Parameters of the circle.------------------------------------------------
conf.a3  = 1;
conf.b3  = 1;
conf.r3  = 400;
% -------------------------------------------------------------------------

% Parameters of Gaussian Distribution.-------------------------------------
conf.Rgain = 1e8;
conf.Rvar  = 400;
mu         = [conf.Pt(1)  conf.Pt(2)];
sigma      = [conf.Rvar^2 0 ; 0 conf.Rvar^2];
conf.f_gmm = @(x,y)mvnpdf([x y],mu,sigma);
% -------------------------------------------------------------------------

%% Other parameters.-------------------------------------------------------
conf.V_action_steps = (conf.Vr_max-conf.Vr_min)./(conf.Nactios-[1 1 1]);
conf.feature_step   = [200, 30, 30 600];
conf.feature_min    = [0, -45, -45 0];
conf.feature_max    = [conf.maxDistance_x, 45, 45 conf.Pb(1)];

%% ------------------------------------------------------------------------
if conf.DRAWS
    size_f = get(0,'ScreenSize');
    figure('position',[0.1*size_f(3) 0.05*size_f(4) 0.85*size_f(3) 0.7*size_f(4)]);
end
% -------------------------------------------------------------------------

%% Run Inwalk-Passing.-----------------------------------------------------
% parfor n = 1:RUNS
for n = 1:RUNS
    [pscored(:,n),scored(:, n),dBT(:, n),Q{n},Qy{n},Qw{n}] = Dribbling2d( n, conf, RL );
end

pf_min   = Inf;
pf_max   = -Inf;
interval = 0.7;

for i = 1:RUNS
    pf(i)    = mean(dBT(ceil(interval*conf.episodes):end,i));
    pf_sd(i) = std(dBT(ceil(interval*conf.episodes):end,i));
    
    if pf(i) < pf_min
        pf_min = pf(i);
    end
    if pf(i) > pf_max
        pf_max          = pf(i);
        results.Qok_x   = Q{i};
        results.Qok_y   = Qy{i};
        results.Qok_rot = Qw{i};
    end
end

results.performance(2,3) = pf_min;
results.performance(1,3) = mean(pf);
results.performance(3,3) = pf_max;
results.performance(4,3) = mean(pf_sd);

f = mean(pf); % Fitness function: percentage of goals scored

results.mean_goals = mean(dBT,2);
results.std_goals  = std(dBT,0,2);

if conf.fuzzQ
    stringName=['fuz-' stringName];
end

if conf.DRAWS1 == 1
    figure,plot(mean(dBT,2))
    grid
    if conf.record > 0
        saveas(gcf,[folder stringName '.fig'])
    end
end

if conf.Test
    stringName = ['Test-' loadFile];
end
if conf.record > 0
    save ([folder stringName '.mat'], 'results');
end