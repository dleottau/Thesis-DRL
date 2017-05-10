function f = RUN_SCRIPT(x,RUNS,stringName)

folder    = 'Opti/';

loadFile = 'DRL_10Runs_Noise0.01_MA0_alpha0.2_lambda0.95_softmax1_decay7_NeASh10.mat';

global test;
global flagFirst;
global opti;
global prueba;
conf.opti = opti;
conf.Test = test;

conf.fileName   = stringName;
conf.auxRewFlag =0;
%% Parameters.-------------------------------------------------------------
conf.episodes      = 2000;   % Maximum number of episodes
conf.Ts            = 0.2;    % Sample time of a RL step
conf.maxDistance   = 4000;   % Max ball distance permited before to end the episode X FIELD DIMENSION
conf.maxDistance_x = 9000;   % Max ball distance permited before to end the episode X FIELD DIMENSION
conf.maxDistance_y = 6000;   % Max ball distance permited before to end the episode Y FIELD DIMENSION
conf.Runs          = RUNS;   % # of runs
conf.NOISE         = 0.01;   % Noise 0-1
conf.DRL           = 1;      % Decentralized RL(1) or Centralized RL(0)
conf.DRAWS1        = 0;      % Enable disable graphics
conf.fuzzQ         = 0;      % Enables fuzzy Q learning algorithm
conf.MAapproach    = x(6);   % 0 no cordination, 1 frequency adjusted, 2 leninet
conf.Mtimes        = 0;      % State-action pair must be visited M times before Q being updated
conf.flag_Vr       = 1;      % 1 learning ; 0  controller.-
conf.thT           = 50;     % threshold to compute Time to threshold
conf.TRANSFER      = x(8);   % =1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies
RL.param.aScale    = x(10);     % Scale factor for the action space in neash
conf.nash          = RL.param.aScale;   % 0 COntrol sharing, 1 NASh, 2 Nash triang

% -------------------------------------------------------------------------
conf.deltaVw    = 2;
conf.Vr_max     = [120 70 30];    % x,y,rot Max Speed achieved by the robot.-
conf.Vr_min     = -conf.Vr_max;
conf.Vr_min(1)  = 0;
conf.Fr         = 150*5;    % Friction coefficient
conf.Controller = x(9);         % % HiQ=0 or lowQ=1 Controlller
% -------------------------------------------------------------------------
conf.maxDeltaV  = conf.Vr_max .* [1/3 1/3 1/3];    % mm/s/Ts
conf.Nactios    = [16,15,17];
% -------------------------------------------------------------------------
conf.sync.nash = 1;
conf.sync.TL   = 1;
conf.sync.expl = 1;
% -------------------------------------------------------------------------

if conf.TRANSFER
    conf.sync.expl = 1;
end
if conf.TRANSFER < 0
    conf.episodes = 100;
end

% -------------------------------------------------------------------------
conf.DRAWS1 = 1;
conf.record = 0;
if conf.opti
    conf.DRAWS1 = 0;
    conf.record = 1;
    folder = 'Opti/';
elseif ~prueba && ~conf.opti
    conf.DRAWS1  = 0;
    conf.record = 1;
    folder = 'tests/';
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
RL.param.exp_decay = x(3);      % Exploration decay parameter
RL.param.beta      = x(5);      % 0.9 Lenience discount factor
RL.param.k         = x(7);      % 1.5 Lenience parameter

%% Inwalk-Passing parameters.----------------------------------------------
% Target and ball position.------------------------------------------------
conf.Pt = [0 0];          % Target Position
conf.Pb = [1500 0];       % Initial ball position
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
conf.goalSize   = 1500;
conf.PgoalPostR = [conf.Pt(1), conf.Pt(2)+conf.goalSize/2];     % Right Goal Post position
conf.PgoalPostL = [conf.Pt(1), conf.Pt(2)-conf.goalSize/2];     % Left Goal Post position
% -------------------------------------------------------------------------

% Parameters of the Robot Initial position.--------------------------------
conf.r_int = 950;   % 950;
conf.r_ext = 1050;   % 1050;
conf.c_ang = 90;
% -------------------------------------------------------------------------

% Parameters of the circle.------------------------------------------------
conf.a3  = 1;
conf.b3  = 1;
conf.r3  = 500;
% -------------------------------------------------------------------------

% Parameters of Gaussian Distribution.-------------------------------------
conf.Rgain = 200;           % 100;
conf.Rvar  = 300;
mu         = [conf.Pt(1)  conf.Pt(2)];
sigma      = [conf.Rvar^2 0 ; 0 conf.Rvar^2];
conf.f_gmm = @(x,y)mvnpdf([x y],mu,sigma);
% -------------------------------------------------------------------------

%% Other parameters.-------------------------------------------------------
conf.V_action_steps = (conf.Vr_max-conf.Vr_min)./(conf.Nactios-[1 1 1]);
%conf.feature_step   = [50, 10, 20, 600];
conf.feature_max    = [800, 70, 90 conf.Pb(1)];
conf.feature_min    = [0, -70, -90, 0];
conf.Nfeatures      = [15, 11, 13, 10];
conf.feature_step   = (conf.feature_max - conf.feature_min )./(conf.Nfeatures-[1 1 1 1]);
% -------------------------------------------------------------------------
conf.Q_INIT = 0;                    % Q table initial values
if conf.TRANSFER && conf.nash
    %conf.Q_INIT = 5;                % if NeASh, optimistic initialization
    conf.Q_INIT = 3;
    %conf.Q_INIT = 0;
elseif conf.TRANSFER && ~conf.nash
    conf.Q_INIT = -3/RL.param.gamma;               % if CoSh, pessimistic initialization
end
%% -----------------------------------------------------------------------
fileNameP = ['DRL_' int2str(conf.Runs) 'Runs_Noise' num2str(conf.NOISE) '_MA' int2str(conf.MAapproach) '_alpha' num2str(RL.param.alpha) '_lambda' num2str(RL.param.lambda)];
if RL.param.softmax > 0
    fileName = ['_softmax' int2str(RL.param.softmax) '_decay' num2str(RL.param.exp_decay)];
else
    fileName = ['_epsilon' num2str(RL.param.epsilon) '_decay' num2str(RL.param.exp_decay)];
end

if conf.MAapproach == 2
    fileName = [fileNameP '_k' num2str(RL.param.k) '_beta' num2str(RL.param.beta) fileName ];
else
    fileName = [fileNameP fileName];
end

if conf.nash && conf.TRANSFER
    fileName = [fileName '_NeASh' num2str(RL.param.aScale)];
elseif ~conf.nash && conf.TRANSFER
    fileName = [fileName '_CoSh'];
end

% ------------------------------------------------------------------------
loadFile        = [folder loadFile];
evolutionFile   = [folder fileName ];
performanceFile = loadFile;
conf.fileName   = fileName;

%% ------------------------------------------------------------------------
if conf.DRAWS1 == 1
    size_f = get(0,'ScreenSize');
    figure('position',[0.1*size_f(3) 0.05*size_f(4) 0.85*size_f(3) 0.7*size_f(4)]);
end

% -------------------------------------------------------------------------
if conf.TRANSFER < 0                        % Para pruebas de performance
    results  = importdata(loadFile);
    RL.Q     = results.Qx_best;
    RL.Q_y   = results.Qy_best;
    RL.Q_rot = results.Qw_best;
    clear results;
end

% -------------------------------------------------------------------------
if flagFirst
    flagFirst = false;
    disp('-');
    disp(evolutionFile);
    disp('-');
end

%% Run Inwalk-Passing.-----------------------------------------------------
if conf.Runs==1
    for n = 1:conf.Runs
        [pscored(:,n),scored(:, n),dBT(:, n),Q{n},Qy{n},Qw{n}] = Dribbling2d( n, conf, RL );
    end
else    
    parfor n = 1:conf.Runs
        [pscored(:,n),scored(:, n),dBT(:, n),Q{n},Qy{n},Qw{n}] = Dribbling2d( n, conf, RL );
    end
end

pf_min   = Inf;
pf_max   = -Inf;
interval = 0.7;

for i = 1:RUNS
    %pf(i)    = mean(dBT(ceil(interval*conf.episodes):end,i));
    %pf_sd(i) = std(dBT(ceil(interval*conf.episodes):end,i));
    %pf(i)    = mean(100-pscored(ceil(interval*conf.episodes):end,i));
    %pf_sd(i) = std(100-pscored(ceil(interval*conf.episodes):end,i));
    pf(i)    = mean(100-pscored(end,i));
    pf_sd(i) = std(100-pscored(end,i));
    
          
    if pf(i) > pf_min
        pf_min = pf(i);
    end
    if pf(i) > pf_max
        pf_max          = pf(i);
        results.Qok_x   = Q{i};
        results.Qok_y   = Qy{i};
        results.Qok_rot = Qw{i};
    end
end

results.performance(1,1) = mean(pf);
results.performance(2,1) = pf_min;
results.performance(3,1) = pf_max;
results.performance(4,1) = mean(pf_sd);

f = mean(pf); % Fitness function: percentage of distance from ball to target

results.mean_dbt = mean(dBT,2);
results.std_dbt  = std(dBT,0,2);

% -----------------------------------------
results.mean_goals = mean(pscored,2);
results.std_goals  = std(pscored,0,2);

results.mean_goalsC = mean(scored,2);
results.std_goalsC  = std(scored,0,2);
% -----------------------------------------

Tth = conf.episodes;
if conf.thT >= min(results.mean_dbt)
    tth = find(results.mean_dbt < conf.thT);
    Tth = tth(1);
end
results.performance(1,2)= Tth;

if conf.fuzzQ
    stringName = ['fuz-' stringName];
end

results.conf = conf;
results.RLparam = RL.param;

if conf.TRANSFER >= 0
    if conf.record
        %save ([evolutionFile  '.mat'], 'results');
        save ([folder stringName  '.mat'], 'results');
    end
    
    if conf.DRAWS1 == 1
        figure,plot(mean(dBT,2))
        grid
        
        if conf.record
            %saveas(gcf,[evolutionFile '.fig'])
            saveas(gcf,[folder stringName '.fig'])
        end
    end
    close(gcf)
else
    if conf.record > 0
        %save ([performanceFile '.mat'], 'results');
        save ([folder stringName '.mat'], 'results');
    end
end

