function f = optimizationFunction(x)

global RUNS;

fitness = MC3D_run(x,RUNS);
f=-fitness;

disp(['Fitness:',num2str(fitness),'; alpha:',num2str(x(1)),'; epsilon:',num2str(x(2))]);
%disp(['Fitness: ',num2str(fitness),'  alpha:',num2str(params.alpha),'  epsilon:',num2str(params.epsilon),'  exp_decay:',num2str(params.exp_decay)])


