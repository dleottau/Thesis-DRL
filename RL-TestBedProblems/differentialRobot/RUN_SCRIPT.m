clear all
clc
clf
close all
%dbstop in Episode.m at 133
%dbstop in UpdateSARSA at 26
%dbstop in GetBestAction at 9
%dbstop in GetBestAction at 21
%dbstop getFeatureVector at 40
dbstop movDiffRobot at 82


tic
conf.episodes = 300;   % maximum number of  episode
conf.Ts = 0.2; %Sample time of a RL step
conf.maxDistance = 800;    % maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.Runs = 5;
conf.NOISE = 0.01;
conf.DRL = 1; %Decentralized RL(1) or Centralized RL(0)
conf.DRAWS = 1;

conf.Pt=[conf.maxDistance/2 0];
%conf.posr=[0.4*conf.maxDistance 0.7*conf.maxDistance 0; 0.5*conf.maxDistance 0.7*conf.maxDistance 0; 0.6*conf.maxDistance 0.7*conf.maxDistance 0];
%conf.posb=[0.4*conf.maxDistance 0.2*conf.maxDistance; 0.5*conf.maxDistance 0.2*conf.maxDistance; 0.6*conf.maxDistance 0.2*conf.maxDistance;];
conf.posr=[0.5*conf.maxDistance 0.5*conf.maxDistance 0];
conf.posb=[0.5*conf.maxDistance 0.3*conf.maxDistance];

conf.Q_INIT = 0;
conf.EXPL_EPISODES_FACTOR = 5;
%if ~conf.DRL 
%    conf.EXPL_EPISODES_FACTOR = conf.EXPL_EPISODES_FACTOR*2/3;
%end
    
conf.Vr_max = [300 10]; %x,y,rot Max Speed achieved by the robot
conf.Vr_min = -conf.Vr_max;
conf.Vr_min(1) = 1;

conf.feature_step = [200, 30, 30]; %[50, 10, 10]  %states
conf.feature_min = [0, -90, -90];
conf.feature_max = [800, 90, 90];
conf.maxDeltaV = conf.Vr_max.*[1/3 1/3]; %mm/s/Ts
conf.Nactios = [5,5];
conf.V_action_steps = (conf.Vr_max-conf.Vr_min)./(conf.Nactios-[1 1]);
conf.Vr_min(1) = 0;


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
    
    [reward(:,:,i), e_time(:,i), Vavg(:,i), accuracy(:,i),  RL] = Dribbling2d( i, conf);
        
                                      
    et(i) = mean(e_time(ceil(interval*conf.episodes):end,i));
    if et(i) < et_min
        et_min=et(i);
    end
    if et(i) > et_max
        et_max=et(i);
    end
       
    vm(i) = mean(Vavg(ceil(interval*conf.episodes):end,i));
    if vm(i) > v_max
        v_max=vm(i);
    end
    if vm(i) < v_min
        v_min=vm(i);
    end
        
    pf(i) = mean(accuracy(ceil(interval*conf.episodes):end,i));
    if pf(i) < pf_min
        pf_min=pf(i);
    end
    if pf(i) > pf_max
        pf_max=pf(i);
    end
    
    cr(i) = mean(reward(ceil(interval*conf.episodes):end,1,i)) + mean(reward(ceil(interval*conf.episodes):conf.episodes,2,i));
    if cr(i) > cr_max
        cr_max=cr(i);
        et_xxx=et(i);
        v_xxx=vm(i);
        pf_xxx=pf(i);
        results.Qok_x = RL.Q;
        if conf.DRL
            results.Qok_rot = RL.Q_rot;
        end
    end
    if cr(i) < cr_min
        cr_min=cr(i);
    end
    
end

results.performance(3,1)=v_min;
results.performance(1,1)=mean(vm);
results.performance(2,1)=v_max;

results.performance(2,2)=et_min;
results.performance(1,2)=mean(et);
results.performance(3,2)=et_max;

results.performance(2,3)=pf_min;
results.performance(1,3)=mean(pf);
results.performance(3,3)=pf_max;

results.performance(3,4)=cr_min;
results.performance(1,4)=mean(cr);
results.performance(2,4)=cr_max;

results.performance(4,4)=cr_max;
results.performance(4,3)=pf_xxx;
results.performance(4,2)=et_xxx;
results.performance(4,1)=v_xxx;

results.mean_Vavg = mean(Vavg,2);
results.std_Vavg = std(Vavg,0,2);
results.mean_faults = mean(accuracy,2);
results.std_faults = std(accuracy,0,2);
results.mean_eTime = mean(e_time,2);
results.std_eTime = std(e_time,0,2);

results.mean_rewX = mean(reward(:,1),2);
results.std_rewX = std(reward(:,1),0,2);
%results.mean_rewY = mean(reward(:,2),2);
%results.std_rewY = std(reward(:,2),0,2);
results.mean_rewRot = mean(reward(:,2),2);
results.std_rewRot = std(reward(:,2),0,2);

save results;

if conf.DRAWS==1
    figure
    subplot(2,2,1)
    plot(mean(reward(:,1),2),'r')
    hold on
    plot(mean(reward(:,2),2),'g')
    %plot(mean(reward(:,3),2),'b')
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
    title('Mean %Accuracy')
    drawnow
    
    
%     figure,plot(mean(reward,2))
%     figure,plot(mean(fitness,2))
%     figure,plot(mean(Vavg,2))
%     figure,plot(mean(tp_faults,2))
end

toc




