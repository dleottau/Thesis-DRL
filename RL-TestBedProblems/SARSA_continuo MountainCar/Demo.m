
clc
clf
close all
clear all

dbstop in UpdateSARSA.m at 28% if isnan(sum(sum(Q)))

params.alpha = 0.15;  
params.gamma = 0.99;   
params.lambda = 0.95;
params.epsilon = 0.01; 
params.exp_decay = 0.99;

RUNS=10;

for n=1:RUNS
    params.runs=n;
    episodes=70;
    cumR(n) = MountainCarDemo(episodes,params);
end

fitness = mean(cumR);

disp(['Fitness: ',num2str(fitness),'  alpha:',num2str(params.alpha),'  gamma:',num2str(params.gamma),'  lambda:',num2str(params.lambda)])
