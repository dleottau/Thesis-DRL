interval=0.7;
for n=1:size(results.Vavg,2)
    mF =  1/2*(100-results.Vavg(:,n) + results.faults(:,n));
    F(n) = mean(mF(ceil(interval*length(mF)):end));
end
[(1:length(F))', F']
 
evolutionFile = 'C:\Users\leottau\Desktop\Thesis-DRL\finalTests\DRL_25Runs_Noise0.1_MA1_alpha0.1_lambda0.9_softmax21_decay8';

Vavg=results.Vavg;
tp_faults=results.faults;
e_time=results.time;
reward=results.reward;

et_min=Inf;
cr_max=-Inf;
v_max=-Inf;
pf_min=Inf;

et_max=-Inf;
cr_min=Inf;
v_min=Inf;
pf_max=-Inf;

interval=0.7;
conf.episodes=2000;

for i=1:size(results.Vavg,2)

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
%         results.Qx_best=Qx{i};
%         results.Qy_best=Qy{i};
%         results.Qw_best=Qrot{i};
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

%results.conf = conf;
%results.RLparam = RL.param;

save ([evolutionFile  '.mat'], 'results');

