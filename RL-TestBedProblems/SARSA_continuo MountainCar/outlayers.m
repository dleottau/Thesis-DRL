interval=0.7;
for n=1:length(results.reward)
    mRew(:,n) =  mean(results.reward{n}(:,:),2);
    cr(n) = mean(mRew(ceil(interval*length(mRew)):end,n));
end
cr'

results.mean_cumReward = mean(mRew,2);
results.std_cumReward = std(mRew,0,2);

cfg.feature_min = [-1.2 -0.07  -1.2 -0.07];
cfg.feature_max = [ 0.6  0.07   0.6  0.07];

subplot(2,1,1)
plot(results.mean_cumReward,'k')
title('Mean Cum.Reward')

subplot(2,1,2)
plot(results.x_best(:,1), results.x_best(:,3),'ok')
axis([1.1*cfg.feature_min(1) 1.1*cfg.feature_max(1) 1.1*cfg.feature_min(3) 1.1*cfg.feature_max(3)])
title('Best policy - Top view (x-y) ') 

evolutionFile='/media/dlf/Data_DLF/Documents_DLF/Publications_DLF/Dribbling/Matlab/Dribbling-2D/Dribbling-2D v20/RL-TestBedProblems/SARSA_continuo MountainCar/experimentsFull/DRL1_24RUNS_epsilon0.05_decay0.99_alpha0.15_lambda0.9_MA1';
saveas(gcf,[evolutionFile '.fig'])
save ([evolutionFile '.mat'], 'results');