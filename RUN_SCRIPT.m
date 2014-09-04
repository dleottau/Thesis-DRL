clear all
clc
close all

episodes = 1000;   % maximum number of  episode
maxDistance = 6000;    % maximum ball distance permited before to end the episode X FIELD DIMENSION
th_max = [250 15 15];      % maximum pho desired
Runs = 2;
NOISE = 0.0;
tic
DRAWS = 1;

Q_INIT = 0;
TRANSFER = 1;  %=1 transfer, >1 acts gready from source policy, =0 learns from scratch,
EXPL_EPISODES_FACTOR = 3;

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


for i=1:Runs
%    disp(['Test= ', num2str(a), '.', num2str(i), ' lambda= ', num2str(lambda(a))])
    [reward(:,i), fitness(:,i), Vavg(:,i), tp_faults(:,i), Q] = Dribbling2d( i, DRAWS, episodes,maxDistance,th_max,NOISE, Q_INIT, TRANSFER, EXPL_EPISODES_FACTOR);
                              
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