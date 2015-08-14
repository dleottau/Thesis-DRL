function fitness = optimizationFunction(x)

%x=clipDLF(x,zeros(1,size(x,2)),ones(1,size(x,2)));

params.alpha = 0.1;  
params.gamma = 0.99;   
params.lambda = 0.95;
params.epsilon = 0.01; 
params.exp_decay = 0.99;


%params.alpha = x(1);  
%params.gamma = x(2);   
%params.lambda = x(2);
params.epsilon = x(1); 
params.exp_decay = x(2);

RUNS=5;

for n=1:RUNS
    params.runs=n;
    episodes=50;
    cumR(n) = MountainCarDemo(episodes,params);
end
fitness = mean(cumR);

%disp(['Fitness: ',num2str(fitness),'  alpha:',num2str(params.alpha),'  gamma:',num2str(params.gamma),'  lambda:',num2str(params.lambda)])
disp(['Fitness: ',num2str(fitness),'  epsilon:',num2str(params.epsilon),'  exp_decay:',num2str(params.exp_decay)])


