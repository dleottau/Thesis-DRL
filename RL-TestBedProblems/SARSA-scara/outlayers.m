interval=0.5;
for n=1:size(results.cumSteps,2)
    f_i(n)=mean(results.cumSteps(ceil(interval*100):end,n));
end
[(1:length(f_i))', f_i']

results.f_i=f_i;
results.cumSteps_mean = mean(results.cumSteps,2);
results.cumSteps_std = std(results.cumSteps,0,2);
results.f=mean(results.f_i);

evolutionFile='finalTests/e-greedy-MAapproach2; gamma1; epsilon0.01; alpha0.3; lenientBeta0.8; lenientGain2.1_';
save ([evolutionFile '.mat'], 'results');


