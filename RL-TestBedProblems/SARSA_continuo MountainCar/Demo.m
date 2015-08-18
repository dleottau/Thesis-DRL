clc
clf
close all
clear all

dbstop in UpdateSARSA.m at 28% if isnan(sum(sum(Q)))

cfg.DRL = 0;  % 0 for CRL, 1 for DRL, 2 for DRL with joint states
RUNS = 1;
cfg.episodes = 300;
cfg.DRAWS = 1;

cfg.feature_min = [-1.2 -0.07  -1.2 -0.07];
cfg.feature_max = [ 0.6  0.07   0.6  0.07];
cfg.init_condition = [-pi()/6   0.0 -pi()/6 0.0];
cfg.nCores = [9 6 9 6];
cfg.stdDiv = [.5 .5 .5 .5];
cfg.actionStep = [1 1];
cfg.goalState = [0.5 0.5];
cfg.maxsteps    = 5000;              % maximum number of steps per episode

RL.q_init = 0;
RL.param.softmax = 10;  % >0 Boltzmann temperature, <= 0 e-greaddy
RL.param.alpha = 0.15;  
RL.param.gamma = 0.99;   
RL.param.lambda = 0.95;
RL.param.epsilon = 0.01; %0.1 CRL, 0.03 DRL
%RL.param.exp_decay = 0.99;
RL.param.exp_decay = 5;
%RL.param.epsilon = 0.7; 

cfg.record = 0;
folder = 'results1/';  
if RL.param.softmax > 0
    fileName = ['DRL' int2str(cfg.DRL) '_' int2str(RUNS) 'RUNS_softmax' int2str(RL.param.softmax) '_decay' num2str(RL.param.exp_decay)];
else
    fileName = ['DRL' int2str(cfg.DRL) '_' int2str(RUNS) 'RUNS_epsilon' int2str(RL.param.epsilon) '_decay' num2str(RL.param.exp_decay)]; 
end
evolutionFile = [folder fileName];

if cfg.DRAWS
    size=get(0,'ScreenSize');
    figure('position',[0.05*size(3) 0.05*size(4) 0.6*size(3) 0.8*size(4)]);
end

cr_max=-Inf;
cr_min=Inf;
f_max=-Inf;
f_min=Inf;


for n=1:RUNS
    cfg.runs=n;
    [reward(:,:,n), f(n), x_, Qx, Qy] = MountainCarDemo(cfg, RL);
    
    interval=0.8;
    fm(n) = -f(n);
    if fm(n) > f_max
        f_max=fm(n);
    end
    if fm(n) < f_min
        f_min=fm(n);
    end
    
    mRew(:,n) =  mean(reward(:,:,n),2);
    cr(n) = mean(mRew(ceil(interval*cfg.episodes):end,n));
    if cr(n) > cr_max
        cr_max=cr(n);
        fm_best=fm(n);
        x_best=x_;
        results.Qx_best = Qx;
        results.Qy_best = Qy;
    end
    if cr(n) < cr_min
        cr_min=cr(n);
    end
    
end

results.reward = reward;
results.x_best = x_best;

results.performance(3,1)=cr_min;
results.performance(1,1)=mean(cr);
results.performance(2,1)=cr_max;
results.performance(4,1)=cr_max; %best

results.performance(3,2)=f_min;
results.performance(1,2)=mean(fm);
results.performance(2,2)=f_max;
results.performance(4,2)=fm_best; %best

results.mean_cumReward = mean(mRew,2);
results.std_cumReward = std(mRew,0,2);

if cfg.record
        save (evolutionFile, 'results');
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

%disp(['Fitness: ',num2str(fitness),'  alpha:',num2str(params.alpha),'  gamma:',num2str(params.gamma),'  lambda:',num2str(params.lambda)])
disp(['  MeanCumRew:',num2str(mean(cr)), ';  Fitness: ',num2str(mean(fm))])
