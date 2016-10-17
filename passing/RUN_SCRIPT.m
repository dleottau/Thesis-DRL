function f = RUN_SCRIPT(x,RUNS,stringName)

folder    = 'Opti/';

loadFile = 'DRL_10Runs_Noise0.01_MA0_alpha0.2_lambda0.95_softmax1_decay7_NeASh10.mat';

global test;
global flagFirst;
global opti;
global prueba;
conf.opti = opti;
conf.Test = test;

conf.fileName = stringName;

%% Parameters.-------------------------------------------------------------
conf.episodes      = 1500;   % Maximum number of episodes
conf.Ts            = 0.2;    % Sample time of a RL step
conf.maxDistance   = 4000;   % Max ball distance permited before to end the episode X FIELD DIMENSION
conf.maxDistance_x = 6000;   % Max ball distance permited before to end the episode X FIELD DIMENSION
conf.maxDistance_y = 4000;   % Max ball distance permited before to end the episode Y FIELD DIMENSION
conf.Runs          = RUNS;   % # of runs
conf.NOISE         = 0.01;   % Noise 0-1
conf.DRL           = 1;      % Decentralized RL(1) or Centralized RL(0)
conf.DRAWS1        = 1;      % Enable disable graphics
conf.fuzzQ         = 0;      % Enables fuzzy Q learning algorithm
conf.MAapproach    = x(6);   % 0 no cordination, 1 frequency adjusted, 2 leninet
conf.TRANSFER      = x(8);   % =1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies
conf.nash          = x(9);   % 0 COntrol sharing, 1 NASh, 2 Nash triang
conf.Mtimes        = 0;      % State-action pair must be visited M times before Q being updated
conf.flag_Vr       = 1;      % 1 learning ; 0  controller.-
conf.thT           = 50;     % threshold to compute Time to threshold
% -------------------------------------------------------------------------
conf.Q_INIT = 0;                    % Q table initial values

if conf.TRANSFER && conf.nash
    conf.Q_INIT = 0;                % if NeASh, optimistic initialization
elseif conf.TRANSFER && ~conf.nash
    conf.Q_INIT = -0;               % if CoSh, pessimistic initialization
end

% -------------------------------------------------------------------------
% Target and ball position.------------------------------------------------
conf.Pt = [0 0];          % Target Position
conf.Pb = [1800 0];       % Initial ball poition
% -------------------------------------------------------------------------
conf.deltaVw   = 2;
conf.Vr_max    = [100 40 40];    % x,y,rot Max Speed achieved by the robot.-
conf.Vr_min    = -conf.Vr_max;
conf.Vr_min(1) = 0;
conf.Fr        = 150;            % Friction coefficient
conf.maxDeltaV = conf.Vr_max .* [1/3 1/3 1/3];    % mm/s/Ts
conf.Nactios   = [12,13,8];
conf.V_action_steps = (conf.Vr_max-conf.Vr_min)./(conf.Nactios-[1 1 1]);
conf.feature_max    = [1000, 60, 90 conf.Pb(1)];
conf.feature_min    = [0, -60, -90, 0];
conf.Nfeatures      = [20, 12, 10, 4];
conf.feature_step   = (conf.feature_max-conf.feature_min)./(conf.Nfeatures-[1 1 1 1]);
%conf.feature_step   = [50, 10, 20, 600];
% -------------------------------------------------------------------------
conf.sync.nash = 1;
conf.sync.TL   = 1;
conf.sync.expl = 1;

if conf.TRANSFER
    conf.sync.expl = 1;
end
if conf.TRANSFER < 0
    conf.episodes = 100;
end
% -------------------------------------------------------------------------
if conf.opti
    conf.DRAWS1  = 0;
    conf.record = 1;
    folder = 'opti/';
end
if prueba
    conf.DRAWS1  = 1;
    conf.record = 0;
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
RL.param.aScale    = x(10);     % Scale factor for the action space in neash

%% Inwalk-Passing parameters.----------------------------------------------
% Parameters of the Robot Initial position.--------------------------------
conf.r_int = 700;
conf.r_ext = 1200;
conf.c_ang = 100;
% -------------------------------------------------------------------------

% Parameters of the circle.------------------------------------------------
conf.a3  = 1;
conf.b3  = 1;
conf.r3  = 500;
% -------------------------------------------------------------------------

% Parameters of Gaussian Distribution.-------------------------------------
conf.Rgain = 1e8;
conf.Rvar  = 500;
mu         = [conf.Pt(1)  conf.Pt(2)];
sigma      = [conf.Rvar^2 0 ; 0 conf.Rvar^2];
conf.f_gmm = @(x,y)mvnpdf([x y],mu,sigma);


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
if prueba
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

results.performance(1,1) = mean(pf);
results.performance(2,1) = pf_min;
results.performance(3,1) = pf_max;
results.performance(4,1) = mean(pf_sd);

f = mean(pf); % Fitness function: percentage of distance from ball to target

results.mean_dbt = mean(dBT,2);
results.std_dbt  = std(dBT,0,2);

Tth=conf.episodes;
if conf.thT>=min(results.mean_dbt)
    tth=find(results.mean_dbt<conf.thT);
    Tth=tth(1);
end
results.performance(1,2)=Tth;


if conf.fuzzQ
    stringName=['fuz-' stringName];
end

results.conf = conf;
results.RLparam = RL.param;

if conf.TRANSFER >= 0
    if conf.record >0
        %save ([evolutionFile  '.mat'], 'results');
        save ([stringName  '.mat'], 'results');
    end
    
    if conf.DRAWS1 == 1
        figure,plot(mean(dBT,2))
        grid
        
        if conf.record > 0
            %saveas(gcf,[evolutionFile '.fig'])
            saveas(gcf,[stringName '.fig'])
        end
    end
    close(gcf)
else
    if conf.record > 0
        %save ([performanceFile '.mat'], 'results');
        save ([stringName '.mat'], 'results');
    end
end