%clear all
clc
close all

conf.episodes = 2000;   % maximum number of  episode
conf.maxDistance = 6000;    % maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.th_max = [250 15 15];      % maximum pho desired
conf.Runs = 1;
conf.NOISE = 0.0;
tic
conf.DRAWS = 1;

conf.Q_INIT = 5;
conf.TRANSFER = 0;  %=1 transfer, >1 acts gready from source policy, =0 learns from scratch,
conf.EXPL_EPISODES_FACTOR = 3;


conf.Voffset = 1; %Offset Speed in mm/s
conf.V_action_steps = [25, 20, 20]/1; % /4 works good
conf.Vr_max = [100 40 40]; %x,y,rot Max Speed achieved by the robot
conf.Vr_min = -conf.Vr_max;
conf.Vr_min(1) = conf.Voffset;
conf.feature_step = [50, 10, 10];
conf.feature_min = [0, -30, -30];
conf.feature_max = [600, 30, 30];
conf.maxDeltaV = conf.Vr_max.*[1/3 1/3 1/2]; %mm/s/Ts
conf.Ts = 0.2; %Sample time of a RL step


a_spot={'r' 'g' 'b' 'c' 'm' 'y' 'k' '--r' '--g' '--b' '--c' };


mf_min=Inf;
cr_max=-Inf;
v_max=-Inf;
pf_min=Inf;

mf_max=-Inf;
cr_min=Inf;
v_min=Inf;
pf_max=-Inf;
interval=0.7;


for i=1:conf.Runs
%    disp(['Test= ', num2str(a), '.', num2str(i), ' lambda= ', num2str(lambda(a))])
    [reward(:,i), fitness(:,i), Vavg(:,i), tp_faults(:,i), Q] = Dribbling2d( i, conf);
                              
    mf(i) = mean(fitness(floor(interval*episodes):episodes,i));
    if mf(i) < mf_min
        mf_min=mf(i);
        Qok=Q;
    end
    if mf(i) > mf_max
        mf_max=mf(i);
    end
       
    vm(i) = mean(Vavg(floor(interval*episodes):episodes,i));
    if vm(i) > v_max
        v_max=vm(i);
    end
    if vm(i) < v_min
        v_min=vm(i);
    end
        
    pf(i) = mean(tp_faults(floor(interval*episodes):episodes,i));
    if pf(i) < pf_min
        pf_min=pf(i);
    end
    if pf(i) > pf_max
        pf_max=pf(i);
    end
    
%     cr(i) = mean(reward(floor(interval*episodes):episodes,i));
%     if cr(i) > cr_max
%         cr_max=cr(i);
%         mf_xxx=mf(i);
%         v_xxx=vm(i);
%         pf_xxx=pf(i);
%     end
%     if cr(i) < cr_min
%         cr_min=cr(i);
%     end
    
end

results(3,1)=v_min;
results(1,1)=mean(vm);
results(2,1)=v_max;

results(3,2)=mf_min;
results(1,2)=mean(mf);
results(2,2)=mf_max;

results(2,3)=pf_min;
results(1,3)=mean(pf);
results(3,3)=pf_max;

results(3,4)=cr_min;
results(1,4)=mean(cr);
results(2,4)=cr_max;

% results(4,4)=cr_max;
% results(4,3)=pf_xxx;
% results(4,2)=mf_xxx;
% results(4,1)=v_xxx;

save Qok;
save results;

if DRAWS==1
    figure
    subplot(2,2,1)
    %plot(mean(reward,2))
    %title('Mean Reward')
             
    subplot(2,2,2)
    plot(mean(Vavg,2))
    title('Mean Vavg')
        
    subplot(2,2,3)
    plot(mean(tp_faults,2))
    title('Mean %TimeFaults')
    
    subplot(2,2,4)
    plot(mean(fitness,2))
    title('Mean Fitness')
    drawnow
    
%     figure,plot(mean(reward,2))
%     figure,plot(mean(fitness,2))
%     figure,plot(mean(Vavg,2))
%     figure,plot(mean(tp_faults,2))
end

toc