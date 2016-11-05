function [cumR, itaeM] = MC3D_run (x,RUNS,stringName)

global flagFirst;
global opti;
cfg.opti=opti;

cfg.DRL = x(6);  % 0 for CRL, 1 for DRL, 2 for DRL with joint states
cfg.MAapproach = x(7);   % 0 no cordination, 1 frequency adjusted, 2 leninet
cfg.ac5= x(8);%1;  % enable original proposal which uses 5 actions instead of 9

cfg.DRAWS = 0;
cfg.record = 1;
folder = 'experimentsFull/';

if opti
    folder = 'opti/';
    cfg.DRAWS = 0;
    cfg.record = 1;
end

if RUNS==1
    cfg.DRAWS = 1;
    cfg.record = 0;
end

RL.q_init = 0;
RL.param.softmax = 0;  %3 >0 Boltzmann temperature, <= 0 e-greaddy
RL.param.alpha = x(1);  
RL.param.gamma = 0.99;   
RL.param.lambda = x(2);
RL.param.epsilon = x(3);
RL.param.exp_decay = 0.99;
%RL.param.exp_decay = 5;
% RL.param.epsilon = 0.7; 
RL.param.k = x(4);  % exponent coeficient for leniency
RL.param.beta = x(5);  % exponent coeficient for leniency
RL.param.p=1; % Transfer knowledge probability
RL.param.p_decay   = 0.5; % factor to decay transfer knowledge probability
RL.param.scale(1) = 1; % nash scalization
RL.param.scale(2) = 1; % nash scalization

cfg.transfer = 0;  % flag for trasferring: 0 no-transfer; 1 cosh;
cfg.episodes = 300;
cfg.feature_min = [-1.2 -0.07  -1.2 -0.07];
cfg.feature_max = [ 0.6  0.07   0.6  0.07];
cfg.init_condition = [-pi()/6   0.0 -pi()/6 0.0];
cfg.nCores = [8 5 8 5];
cfg.stdDiv = 0.5;
cfg.actionStep = [1 1];
cfg.goalState = [0.5 0.5];
cfg.maxsteps    = 5000;              % maximum number of steps per episode

if RL.param.softmax > 0
    fileName = ['DRL' int2str(cfg.DRL) '_' int2str(RUNS) 'RUNS_softmax' int2str(RL.param.softmax) '_decay' num2str(RL.param.exp_decay) '_alpha' num2str(RL.param.alpha) '_lambda' num2str(RL.param.lambda) '_MA' num2str(cfg.MAapproach)];
else
    fileName = ['DRL' int2str(cfg.DRL) '_' int2str(RUNS) 'RUNS_epsilon' num2str(RL.param.epsilon) '_decay' num2str(RL.param.exp_decay) '_alpha' num2str(RL.param.alpha) '_lambda' num2str(RL.param.lambda) '_MA-Inc' num2str(cfg.MAapproach)]; 
end

if cfg.ac5
    fileName = ['ac5-' fileName];
end

if cfg.MAapproach == 2
    fileName = [fileName '_k' num2str(RL.param.k) '_beta' num2str(RL.param.beta) ];
end

evolutionFile = [folder fileName];
cfg.fileName=fileName;

if cfg.DRAWS
    size=get(0,'ScreenSize');
    figure('position',[0.05*size(3) 0.05*size(4) 0.6*size(3) 0.8*size(4)]);
end

if flagFirst
    flagFirst=false;
    disp('-');
    disp(evolutionFile);
    disp('-');
end

if RUNS==1
    for n=1:RUNS
        %cfg.runs=n;
        [reward{n}, itae(n), x_{n}, Qx{n}, Qy{n}] = MountainCarDemo(cfg, RL, n);
    end
else
    parfor n=1:RUNS
        [reward{n}, itae(n), x_{n}, Qx{n}, Qy{n}] = MountainCarDemo(cfg, RL, n);
    end
end
        
cr_best=-Inf;
cr_worst=Inf;
itae_best=Inf;
itae_worst=-Inf;

for n=1:RUNS
    interval=0.0001; %0.7
    itaem(n) = itae(n);
    if itaem(n) < itae_best
        itae_best=itaem(n);
    end
    if itaem(n) > itae_worst
        itae_worst=itaem(n);
    end
    
    mRew(:,n) =  mean(reward{n}(:,:),2);
    cr(n) = mean(mRew(ceil(interval*cfg.episodes):end,n));
    if cr(n) > cr_best
        cr_best=cr(n);
        itae_best=itaem(n);
        x_best=x_{n};
        results.Qx_best = Qx{n};
        results.Qy_best = Qy{n};
    end
    if cr(n) < cr_worst
        cr_worst=cr(n);
    end
    
end

results.stringName = stringName;
results.reward = reward;
results.x_best = x_best;

results.performance(1,1)=mean(cr);
results.performance(2,1)=cr_best;
results.performance(3,1)=cr_worst;
results.performance(4,1)=cr_best; %best

results.performance(1,2)=mean(itaem);
results.performance(2,2)=itae_best;
results.performance(3,2)=itae_worst;
results.performance(4,2)=itae_best; %best

results.mean_cumReward = mean(mRew,2);
results.std_cumReward = std(mRew,0,2);
    
if cfg.record
        %save ([evolutionFile '.mat'], 'results');
        save ([folder stringName '.mat'], 'results');
end

if cfg.DRAWS
                      
        figure('position',[0.5*size(3) 0.1*size(4) 0.5*size(3) 0.7*size(4)], 'Name',fileName,'NumberTitle','off');
                
        subplot(2,1,1)
        plot(results.mean_cumReward,'k')
        title('Mean Cum.Reward')

        subplot(2,1,2)
        plot(x_best(:,1),x_best(:,3),'ok')
        axis([1.1*cfg.feature_min(1) 1.1*cfg.feature_max(1) 1.1*cfg.feature_min(3) 1.1*cfg.feature_max(3)])
        title('Best policy - Top view (x-y) ')    
        
        drawnow
        if cfg.record
            saveas(gcf,[evolutionFile '.fig'])
        end
        
end

clear Qx Qy reward x_ mRew;

cumR=mean(cr);
itaeM=mean(itaem);
%disp(['  MeanCumRew:',num2str(mean(cr)), ';  Fitness: ',num2str(mean(fm))])
