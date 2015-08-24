clear all
clc
clf
%close all

%dbstop in softmax_selection.m at 38

tic

conf.episodes = 2000; %500;   %2000  maximum number of  episode
conf.Runs = 1;
conf.NOISE = 0.05;

conf.record =1;
conf.DRAWS = 1;

conf.TRANSFER = 0;  %=1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies
conf.nash = 0;   % 0 COntrol sharing, 1 NASh
conf.MAapproach = 1;   % 0 no cordination, 1 frequency adjusted, 2 leninet
conf.Mtimes = 0; % state-action pair must be visited M times before Q being updated
conf.Q_INIT = 0;

%sync=1, synchronizes using tne same random number for the 3 D-RL agents, otherwise, uses independetn random numbers per agent
conf.sync.nash      = 0;
conf.sync.TL        = 0;
conf.sync.expl      = 0;

RL.param.alpha      = 0.5;   % 0.3-0.5 learning rate
RL.param.gamma      = 1;   % discount factor
RL.param.lambda     = 0.9;   % the decaying elegibiliy trace parameter
RL.param.epsilon    = 1;
RL.param.exp_decay  = 8; % 8 exploration decay parameter
RL.param.softmax    = 20;   % Boltzmann temperature (5 by default), if <= 0 e-greaddy
RL.param.beta       = 0.7;   % lenience discount factor
RL.param.k          = 1.5;   % lenience parameter


%evolutionFile = 'MAS-coop/DRL-3runs-Noise005-2000exp8-NoSync-FAboltzman20';
%performanceFile = 'boltzmann/Vx-5runs-Noise03-50exp30-NoSync-boltzmann1';


conf.maxDistance =6000;    % maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.th_max = [250 15 15];      % maximum pho desired


conf.Voffset = 1; %Offset Speed in mm/s
conf.V_action_steps = [25, 20, 20]/4; % /4 works good
conf.Vr_max = [100 40 40]; %x,y,rot Max Speed achieved by the robot
conf.Vr_min = -conf.Vr_max;
conf.Vr_min(1) = conf.Voffset;
conf.feature_step = [50, 10, 10];
conf.feature_min = [0, -30, -30]; %-30, -30
conf.feature_max = [600, 30, 30]; %30, 30
conf.maxDeltaV = conf.Vr_max.*[1/3 1/3 1/2]; %mm/s/Ts
conf.Ts = 0.2; %Sample time of a RL step


a_spot={'r' 'g' 'b' 'c' 'm' 'y' 'k' '--r' '--g' '--b' '--c' };


folder = 'MAS-coop/';  
loadFile = 'resultsFull_NASh-v2-20runs-Noise01-exp8.mat';


fileNameP = ['DRL_Noise' num2str(conf.NOISE) '_MA' int2str(conf.MAapproach)];
if RL.param.softmax > 0
    fileName = ['_softmax' int2str(RL.param.softmax) '_decay' num2str(RL.param.exp_decay) '_alpha' num2str(RL.param.alpha)];
else
    fileName = ['_epsilon' num2str(RL.param.epsilon) '_decay' num2str(RL.param.exp_decay) '_alpha' num2str(RL.param.alpha)]; 
end

if conf.MAapproach == 2
    fileName = [fileNameP '_k' num2str(RL.param.k) '_beta' num2str(RL.param.beta) fileName ];
else
    fileName = [fileNameP fileName];
end

loadFile = [folder loadFile];
evolutionFile = [folder fileName];
performanceFile = loadFile; 
conf.fileName = fileName;

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


if conf.DRAWS==1
    size=get(0,'ScreenSize');
    figure('position',[0.05*size(3) 0.05*size(4) 0.6*size(3) 0.8*size(4)]);
end


if conf.TRANSFER<0 %Para pruebas de performance
    load loadFile;
end

%========TRANSFER=========
if conf.TRANSFER<0 %Para pruebas de performance
RL.Q        = results.Qok_x;%Qx_DRL;
RL.Q_y      = results.Qok_y;%Qy_DRL;
RL.Q_rot    = results.Qok_rot;%Qrot_DRL;
clear results;
end
%========================

for i=1:conf.Runs
    conf.nRun=i;
%    disp(['Test= ', num2str(a), '.', num2str(i), ' lambda= ', num2str(lambda(a))])
    [reward(:,:,i), e_time(:,i), Vavg(:,i), tp_faults(:,i), goals(i),  Qx,Qy,Qrot] = Dribbling2d(conf, RL);
                              
    et(i) = mean(e_time(ceil(interval*conf.episodes):conf.episodes,i))/1.5;
    et_sd(i) = std(e_time(ceil(interval*conf.episodes):conf.episodes,i))/1.5;
    if et(i) < et_min
        et_min=et(i);
    end
    if et(i) > et_max
        et_max=et(i);
    end
       
    vm(i) = mean(Vavg(ceil(interval*conf.episodes):conf.episodes,i));
    vm_sd(i) = std(Vavg(ceil(interval*conf.episodes):conf.episodes,i));
    if vm(i) > v_max
        v_max=vm(i);
    end
    if vm(i) < v_min
        v_min=vm(i);
    end
        
    pf(i) = mean(tp_faults(ceil(interval*conf.episodes):conf.episodes,i));
    pf_sd(i) = std(tp_faults(ceil(interval*conf.episodes):conf.episodes,i));
    if pf(i) < pf_min
        pf_min=pf(i);
    end
    if pf(i) > pf_max
        pf_max=pf(i);
    end
    
    goals(i)=100*goals(i)/conf.episodes;
    goals_avg = mean(goals);
    goals_sd = std(goals);
        
    cr(i) = mean(reward(ceil(interval*conf.episodes):conf.episodes,1,i)) + mean(reward(ceil(interval*conf.episodes):conf.episodes,2,i)) + mean(reward(ceil(interval*conf.episodes):conf.episodes,3,i));
    if cr(i) > cr_max
        cr_max=cr(i);
        et_xxx=et(i);
        v_xxx=vm(i);
        pf_xxx=pf(i);
        results.Qok_x=Qx;
        results.Qok_y=Qy;
        results.Qok_rot=Qrot;
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

results.performance(1,3)=(100-mean(vm)+mean(pf))/2;

results.performance(1,4)=goals_avg;
results.performance(5,4)=goals_sd;
results.performance(6,4)=results.performance(5,4)/conf.Runs;

results.performance(3,5)=cr_min;
results.performance(1,5)=mean(cr);
results.performance(2,5)=cr_max;
results.performance(4,5)=cr_max;%best

results.performance(2,6)=et_min;
results.performance(1,6)=mean(et);
results.performance(3,6)=et_max;
results.performance(5,6)=mean(et_sd);
results.performance(6,6)=results.performance(5,4)/tested_episodes;
results.performance(4,6)=et_xxx; %best



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

if conf.TRANSFER >= 0
    if conf.record >0
        save ([evolutionFile  '.mat'], 'results');
    end
    
    if conf.DRAWS==1
                      
        figure('position',[0.5*size(3) 0.1*size(4) 0.5*size(3) 0.7*size(4)]);
        
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

toc

% smoot
% errorvar


