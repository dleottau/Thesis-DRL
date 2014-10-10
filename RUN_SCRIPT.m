clear all
clc
close all

conf.episodes = 100;   % maximum number of  episode
conf.maxDistance = 6000;    % maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.th_max = [250 15 15];      % maximum pho desired
conf.Runs = 1;
conf.NOISE = 0.12;
tic
conf.DRAWS = 1;

conf.Q_INIT = 0;
conf.TRANSFER = 0;  %=1 transfer, >1 acts gready from source policy, =0 learns from scratch,
conf.EXPL_EPISODES_FACTOR = 5;


conf.Voffset = 1; %Offset Speed in mm/s
conf.V_action_steps = [25, 20, 20]/4; % /4 works good
conf.Vr_max = [100 40 40]; %x,y,rot Max Speed achieved by the robot
conf.Vr_min = -conf.Vr_max;
conf.Vr_min(1) = conf.Voffset;
conf.feature_step = [50, 10, 10];
conf.feature_min = [0, -30, -30];
conf.feature_max = [600, 30, 30];
conf.maxDeltaV = conf.Vr_max.*[1/3 1/3 1/2]; %mm/s/Ts
conf.Ts = 0.2; %Sample time of a RL step


a_spot={'r' 'g' 'b' 'c' 'm' 'y' 'k' '--r' '--g' '--b' '--c' };


et_min=Inf;
cr_max=-Inf;
v_max=-Inf;
pf_min=Inf;

et_max=-Inf;
cr_min=Inf;
v_min=Inf;
pf_max=-Inf;
interval=0.7;


for i=1:conf.Runs
%    disp(['Test= ', num2str(a), '.', num2str(i), ' lambda= ', num2str(lambda(a))])
    [reward(:,:,i), e_time(:,i), Vavg(:,i), tp_faults(:,i),  Qx,Qy,Qrot] = Dribbling2d( i, conf);
                              
    et(i) = mean(e_time(ceil(interval*conf.episodes):conf.episodes,i));
    et_sd(i) = std(e_time(ceil(interval*conf.episodes):conf.episodes,i));
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

results.performance(3,1)=v_min;
results.performance(1,1)=mean(vm);
results.performance(2,1)=v_max;
results.performance(5,1)=mean(vm_sd);

results.performance(2,2)=et_min;
results.performance(1,2)=mean(et);
results.performance(3,2)=et_max;
results.performance(5,2)=mean(et_sd);

results.performance(2,3)=pf_min;
results.performance(1,3)=mean(pf);
results.performance(3,3)=pf_max;
results.performance(5,3)=mean(pf_sd);

results.performance(3,4)=cr_min;
results.performance(1,4)=mean(cr);
results.performance(2,4)=cr_max;

results.performance(4,4)=cr_max;
results.performance(4,3)=pf_xxx;
results.performance(4,2)=et_xxx;
results.performance(4,1)=v_xxx;

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

save results;

if conf.DRAWS==1
    figure
    subplot(2,2,1)
    plot(mean(reward(:,1),2),'r')
    hold on
    plot(mean(reward(:,2),2),'g')
    plot(mean(reward(:,3),2),'b')
    hold
    title('Mean Reward')
    
    subplot(2,2,2)
    plot(results.mean_eTime)
    title('Mean Episode Time')
        
    subplot(2,2,3)
    plot(results.mean_Vavg)
    title('Mean Vavg')
        
    subplot(2,2,4)
    plot(results.mean_faults)
    title('Mean %TimeFaults')
    drawnow
    
    
%     figure,plot(mean(reward,2))
%     figure,plot(mean(fitness,2))
%     figure,plot(mean(Vavg,2))
%     figure,plot(mean(tp_faults,2))
end

toc

% smoot
% errorvar


