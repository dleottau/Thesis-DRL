function f = RUN_SCRIPT(x,RUNS,stringName)

conf.Test = 0;
folder    = 'Opti/';

global flagFirst;
global opti;
conf.opti = opti;

%% Par�metros.--------------------------------------------------------------
conf.episodes    = 1000;    % Maximum number of episodes
conf.Ts          = 0.2;     % Sample time of a RL step
conf.maxDistance = 4000;    % Maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.Runs        = RUNS;    % # of runs
conf.NOISE       = 0.01;    % Noise 0-1
conf.DRL         = x(7);    % Decentralized RL(1) or Centralized RL(0)
conf.DRAWS       = 1;       % Gr�fico en linea
conf.DRAWS1      = 1;       % Enable disable graphics
conf.record      = 0;       % To record logs
conf.fuzzQ       = 0;       % Enables fuzzy Q learning algorithm
conf.MAapproach  = x(8);    % Multi Agent Approach

if conf.opti
    conf.DRAWS  = 0;
    conf.record = 1;
end

conf.Q_INIT               = 0;      % Q table initial values
conf.EXPL_EPISODES_FACTOR = x(1);   % exploration decay factor
RL.param.alpha            = x(3);   % learning rate
RL.param.gamma            = 0.99;   % discount factor
RL.param.lambda           = x(6);   % the decaying elegibiliy trace parameter
RL.param.epsilon          = 1;
RL.param.softmax          = x(2);

if conf.Test                        % Para pruebas de performance
    RL.param.epsilon = 0;
    RL.param.softmax = 0;
end

conf.Rgain = x(4);
conf.Rvar  = x(5);

conf.Pt    = [conf.maxDistance/2 0];       % Target Position
conf.Pb    = [0.5*conf.maxDistance 1000];   % Initial ball poition

conf.deltaVw   = 2;
conf.Vr_max    = [100 40 5];     % x,y,rot Max Speed achieved by the robot.-
conf.Vr_min    = -conf.Vr_max;
conf.Vr_min(1) = 0;
conf.Fr = 150; % Friction coefficient
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
conf.maxDeltaV = conf.Vr_max.*[1/2 1/2 1/2];    % mm/s/Ts
conf.Nactios   = [11,7,5];
% -------------------------------------------------------------------------

if conf.fuzzQ && conf.DRL
    conf.Nactios = [11,7,3];
end

%% ------------------------------------------------------------------------
conf.V_action_steps = (conf.Vr_max-conf.Vr_min)./(conf.Nactios-[1 1 1]);
conf.Vr_min(1)      = 0;
conf.feature_step   = [200, 30, 30 conf.V_action_steps(2)];
conf.feature_min    = [0, -45, -45 conf.Vr_min(2)];
conf.feature_max    = [conf.maxDistance, 45, 45 conf.Vr_max(2)];

%% Par�metros elipse (x^2/a + y^2/b = 1).-
conf.a1  = 1;                                    % a.-
conf.b1  = 1;                                    % b.-
conf.r1  = 10;                                   % radio.-
conf.tx1 = 0;
conf.ty1 = 0;
conf.a3  = 1;                                    % (2/5);
conf.b3  = 1;
conf.r3  = 0.3 * (conf.Pb(2) - conf.Pt(2));
conf.tx3 = 0;
conf.ty3 = 0;

%% Par�metros Distribuci�n Gaussiana.--------------------------------------
mu         = [conf.Pt(1)  conf.Pt(2)];
sigma      = [x(5)^2 0 ; 0 x(5)^2];
conf.f_gmm = @(x,y)mvnpdf([x y],mu,sigma);

%% Continuacion.-----------------------------------------------------------
if conf.DRAWS
    size_f = get(0,'ScreenSize');
    figure('position',[0.1*size_f(3) 0.05*size_f(4) 0.85*size_f(3) 0.7*size_f(4)]);
end

%% Contadores.-
conf.cE = 1;    % Contador Episodios.-

parfor n = 1:RUNS
%for n = 1:RUNS
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

results.performance(2,3) = pf_min;
results.performance(1,3) = mean(pf);
results.performance(3,3) = pf_max;
results.performance(4,3) = mean(pf_sd);

f = mean(pf); % Fitness function: percentage of goals scored

results.mean_goals = mean(pscored,2);
results.std_goals  = std(pscored,0,2);

if conf.fuzzQ
    stringName=['fuz-' stringName];
end

if conf.DRAWS1 == 1
    figure,plot(mean(pscored,2))
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

% %% Score Information.-
% s_plot = [];
% for cont = 1:1:n
%     s_plot = [s_plot ; score_out{cont}];
% end
% 
% m_score = mean(s_plot);
% s_score = std(s_plot);
% 
% figure(3)
% hold on
% plot(s_plot(:,1),s_plot(:,2),'r.')
% h_figur = gcf;
% circle_plot(conf.Pt(1), conf.Pt(2), conf.a3, conf.b3, conf.r3, conf.tx3, conf.ty3, h_figur, 'k')
% circle_plot(conf.Pt(1), conf.Pt(2), conf.a1, conf.b1, conf.r1, conf.tx1, conf.ty1, h_figur, 'b')
% grid
% xlim([300 700])
% ylim([100 350])
% hold off
% 
% fprintf('\n Mean       = [%.2f %.2f]',m_score(1),m_score(2))
% fprintf('\n Std        = [%.2f %.2f]',s_score(1),s_score(2))
% fprintf('\n N� of hits = %.0f\n',size(s_plot,1))