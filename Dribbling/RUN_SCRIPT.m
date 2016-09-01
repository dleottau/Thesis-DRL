function f = RUN_SCRIPT(x,RUNS)

folder = 'opti/';  
%folder = 'finalTests/';  
%loadFile = 'DRL_25Runs_Noise0.1_MA0_alpha0.5_lambda0.9_softmax70_decay6.mat';
%loadFile = 'DRL_25Runs_Noise0.1_MA1_alpha0.1_lambda0.9_softmax21_decay8.mat';
loadFile = 'DRL_25Runs_Noise0.1_MA2_alpha0.1_lambda0.9_k1.5_beta0.9_softmax70_decay6.mat';
% folder = 'RC-2015/results/';  
% loadFile = 'resultsFull_NASh-v2-20runs-Noise01-exp8.mat';

global test;
global flagFirst;
global opti;
conf.opti=opti;

%dbstop in softmax_selection.m at 38

conf.episodes = 1000; %  maximum number of  episode
conf.Runs = RUNS;
conf.record = 1;
conf.DRAWS = 0;
conf.NOISE = 0.1;

conf.TRANSFER = x(8);  %=1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies
conf.nash = x(9);   % 0 COntrol sharing, 1 NASh
conf.MAapproach = x(6);   % 0 no cordination, 1 frequency adjusted, 2 leninet
conf.Mtimes = 0; % state-action pair must be visited M times before Q being updated
conf.Q_INIT = 5;

%sync=1, synchronizes using tne same random number for the 3 D-RL agents, otherwise, uses independetn random numbers per agent
conf.sync.nash      = 1;
conf.sync.TL        = 1;
conf.sync.expl      = 1;
if conf.TRANSFER, conf.sync.expl=1; end
if conf.TRANSFER<0, conf.episodes=100; end

if conf.opti
    conf.DRAWS = 0;
    conf.record = 1;
    folder = 'opti/';
end
if test 
    conf.DRAWS = 1;
    conf.record = 0;
end 

RL.param.alpha      = x(1);   % 0.5;   % 0.3-0.5 learning rate
RL.param.gamma      = 0.99;   % discount factor
RL.param.lambda     = x(4);   % the decaying elegibiliy trace parameter
RL.param.epsilon    = 1;
RL.param.softmax    = x(2);   % Boltzmann temperature (50 by default), if <= 0 e-greaddy
RL.param.exp_decay  = x(3);   % 8 exploration decay parameter
RL.param.k          = x(7);   % 1.5 lenience parameter
RL.param.beta       = x(5);   % 0.9 lenience discount factor
RL.param.aScale      = x(10);    % scale factor for the action space in neash

conf.maxDistance =6000;       % maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.th_max = [250 15 15];    % maximum pho desired

conf.Voffset = 1; %Offset Speed in mm/s
conf.V_action_steps = [25, 20, 20]/4; % /4 works good
conf.Vr_max = [100 40 40]; %x,y,rot Max Speed achieved by the robot
conf.Vr_min = -conf.Vr_max;
conf.Vr_min(1) = conf.Voffset;
conf.feature_step = [50, 10, 10];
conf.feature_min = [0, -40, -40]; %-30, -30
conf.feature_max = [600, 40, 40]; %30, 30
conf.maxDeltaV = conf.Vr_max.*[1/3 1/3 1/2]; %mm/s/Ts
conf.Ts = 0.2; %Sample time of a RL step

%a_spot={'r' 'g' 'b' 'c' 'm' 'y' 'k' '--r' '--g' '--b' '--c' };

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

if conf.nash==1 && conf.TRANSFER
    fileName = [fileName '_NASSh'];
elseif conf.nash==0 && conf.TRANSFER
    fileName = [fileName '_CoSh'];
end
    

loadFile = [folder loadFile];
evolutionFile = [folder fileName ];
performanceFile = loadFile; 
conf.fileName = fileName;

if conf.DRAWS==1
    size=get(0,'ScreenSize');
    figure('position',[0.05*size(3) 0.05*size(4) 0.6*size(3) 0.8*size(4)]);
end


if conf.TRANSFER<0 %Para pruebas de performance
    %load loadFile;
    results=importdata(loadFile);
    RL.Q        = results.Qx_best;
    RL.Q_y      = results.Qy_best;
    RL.Q_rot    = results.Qw_best;
%     RL.Q        = results.Qok_x;
%     RL.Q_y      = results.Qok_y;
%     RL.Q_rot    = results.Qok_rot;
    clear results;
end
%========================

if flagFirst
    flagFirst=false;
    disp('-');
    disp(evolutionFile);
    disp('-');
end

if test
    for i=1:conf.Runs
        [reward(:,:,i), e_time(:,i), Vavg(:,i), tp_faults(:,i),  Qx{i},Qy{i},Qrot{i}] = Dribbling2d(conf, RL, i);
    end
else
    parfor i=1:conf.Runs
        [reward(:,:,i), e_time(:,i), Vavg(:,i), tp_faults(:,i),  Qx{i},Qy{i},Qrot{i}] = Dribbling2d(conf, RL, i);
    end
end      

et_min=Inf;
cr_max=-Inf;
v_max=-Inf;
pf_min=Inf;

et_max=-Inf;
cr_min=Inf;
v_min=Inf;
pf_max=-Inf;

interval=0.7;
if conf.TRANSFER < 0
    interval=0.1;
end

for i=1:RUNS

    et(i) = mean(e_time(ceil(interval*conf.episodes):end,i))/1.5;
    et_sd(i) = std(e_time(ceil(interval*conf.episodes):end,i))/1.5;
    if et(i) < et_min
        et_min=et(i);
    end
    if et(i) > et_max
        et_max=et(i);
    end
       
    vm(i) = mean(Vavg(ceil(interval*conf.episodes):end,i));
    vm_sd(i) = std(Vavg(ceil(interval*conf.episodes):end,i));
    if vm(i) > v_max
        v_max=vm(i);
    end
    if vm(i) < v_min
        v_min=vm(i);
    end
    
       
    pf(i) = mean(tp_faults(ceil(interval*conf.episodes):end,i));
    pf_sd(i) = std(tp_faults(ceil(interval*conf.episodes):end,i));
    if pf(i) < pf_min
        pf_min=pf(i);
    end
    if pf(i) > pf_max
        pf_max=pf(i);
    end
    
         
    cr(i) = mean(reward(ceil(interval*conf.episodes):end,1,i)) + mean(reward(ceil(interval*conf.episodes):end,2,i)) + mean(reward(ceil(interval*conf.episodes):end,3,i));
    if cr(i) > cr_max
        cr_max=cr(i);
        et_xxx=et(i);
        v_xxx=vm(i);
        pf_xxx=pf(i);
        results.Qx_best=Qx{i};
        results.Qy_best=Qy{i};
        results.Qw_best=Qrot{i};
    end
    if cr(i) < cr_min
        cr_min=cr(i);
    end
    
end

tested_episodes=round(conf.episodes-ceil(interval*conf.episodes));

results.time = e_time;
results.faults = tp_faults;
results.reward = reward;
results.Vavg = Vavg;


results.performance(3,1)=v_min;
results.performance(1,1)=mean(vm);
results.performance(2,1)=v_max;
results.performance(5,1)=mean(vm_sd);
results.performance(6,1)=results.performance(5,1)/tested_episodes;
results.performance(4,1)=v_xxx; %best

results.performance(2,2)=pf_min;
results.performance(1,2)=mean(pf);
results.performance(3,2)=pf_max;
results.performance(5,2)=mean(pf_sd);
results.performance(6,2)=results.performance(5,2)/tested_episodes;
results.performance(4,2)=pf_xxx; %best

f=(100-mean(vm)+mean(pf))/2;  % Fitness function
results.performance(1,3)=f;

results.performance(3,4)=cr_min;
results.performance(1,4)=mean(cr);
results.performance(2,4)=cr_max;
results.performance(4,4)=cr_max;%best

results.performance(2,5)=et_min;
results.performance(1,5)=mean(et);
results.performance(3,5)=et_max;
results.performance(5,5)=mean(et_sd);
results.performance(6,5)=results.performance(5,4)/tested_episodes;
results.performance(4,5)=et_xxx; %best



results.mean_Vavg = mean(Vavg,2);
results.std_Vavg = std(Vavg,0,2);
results.mean_faults = mean(tp_faults,2);
results.std_faults = std(tp_faults,0,2);
results.mean_eTime = mean(e_time,2);
results.std_eTime = std(e_time,0,2);

results.mean_rewX = mean(reward(:,1),2);
results.std_rewX = std(reward(:,1),0,2);
results.mean_rewY = mean(reward(:,2),2);
results.std_rewY = std(reward(:,2),0,2);
results.mean_rewRot = mean(reward(:,3),2);
results.std_rewRot = std(reward(:,3),0,2);

results.conf = conf;
results.RLparam = RL.param;

if conf.TRANSFER >= 0
    if conf.record >0
        save ([evolutionFile  '.mat'], 'results');
    end
    
    if conf.DRAWS==1
                      
        figure('position',[0.5*size(3) 0.1*size(4) 0.5*size(3) 0.7*size(4)]);
        set(gcf,'name',['DRL Dribbling ' conf.fileName])
        
        subplot(2,2,4)
        plot(mean(reward(:,1),2),'r')
        hold on
        plot(mean(reward(:,2),2),'g')
        plot(mean(reward(:,3),2),'b')
        hold
        title('Mean Cum.Reward')

        subplot(2,2,3)
        plot((100-results.mean_Vavg+results.mean_faults)/2)
        title('Mean Global Fitness(%)')

        subplot(2,2,1)
        plot(results.mean_Vavg)
        title('Mean %Max.Fw.Speed')

        subplot(2,2,2)
        plot(results.mean_faults)
        title('Mean %TimeFaults')
        drawnow


    %     figure,plot(mean(reward,2))
    %     figure,plot(mean(fitness,2))
    %     figure,plot(mean(Vavg,2))
    %     figure,plot(mean(tp_faults,2))
        
        if conf.record > 0
            saveas(gcf,[evolutionFile '.fig'])
        end
    
    end
    
else
    if conf.record > 0
        save ([performanceFile '.mat'], 'results');
    end
end


