% clear all
% clc
% close all
% 
% evolutionFile='D:\Documents_DLF\Publications_DLF\Dribbling\Matlab\Dribbling-2D\Dribbling-2D v20\3D-MountainCar\experimentsFull\5actions0; MAapproach4; DRL2; beta0.8; k-lenient3.5; epsilon0.02; lambda0.9; alpha1';
% 
% load([evolutionFile '.mat']);

record = 1;
draw = 1;

interval=0.9;
for n=1:length(results.reward)
    mRew(:,n) =  mean(results.reward{n}(:,:),2);
    cr(n) = mean(mRew(ceil(interval*length(mRew)):end,n));
end
[(1:length(cr))', cr']


cr_best=-Inf;
cr_worst=Inf;
itae_best=Inf;
itae_worst=-Inf;

interval=0.9;
for n=1:length(results.reward)
    mRew(:,n) =  mean(results.reward{n}(:,:),2);
    cr(n) = mean(mRew(ceil(interval*length(mRew)):end,n));
    if cr(n) > cr_best
        cr_best=cr(n);
    end
    if cr(n) < cr_worst
        cr_worst=cr(n);
    end
    
end

results.reward = results.reward;

results.performance(1,1)=mean(cr);
results.performance(2,1)=cr_best;
results.performance(3,1)=cr_worst;
results.performance(4,1)=cr_best; %best

mean(cr)

results.mean_cumReward = mean(mRew,2);
results.std_cumReward = std(mRew,0,2);

if draw
    cfg.feature_min = [-1.2 -0.07  -1.2 -0.07];
    cfg.feature_max = [ 0.6  0.07   0.6  0.07];

    size=get(0,'ScreenSize');
    figure('position',[0.5*size(3) 0.1*size(4) 0.5*size(3) 0.7*size(4)], 'Name',evolutionFile,'NumberTitle','off');
    subplot(2,1,1)
    plot(results.mean_cumReward,'k')
    title('Mean Cum.Reward')

    subplot(2,1,2)
    plot(results.x_best(:,1), results.x_best(:,3),'ok')
    axis([1.1*cfg.feature_min(1) 1.1*cfg.feature_max(1) 1.1*cfg.feature_min(3) 1.1*cfg.feature_max(3)])
    title('Best policy - Top view (x-y) ') 
    
    if record
        saveas(gcf,[evolutionFile '.fig'])
    end
end

if record
    save ([evolutionFile '.mat'], 'results');
end

