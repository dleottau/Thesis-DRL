% function f = optimizationFunction(x)
% 
% global RUNS;

clc
clf
clear all
close all

x(1) = 0.1;   % learning rate
x(2) = 0.95;   % lambda
x(3)  = 0.04;  % epsilon

RUNS=1;

fitness = MC3D_run(x,RUNS);
f=-fitness;

disp(['Fitness:',num2str(fitness),'; alpha:',num2str(x(1)),'; lambda:',num2str(x(2)),'; epsilon:',num2str(x(3))]);

%disp(['Fitness: ',num2str(fitness),'  alpha:',num2str(params.alpha),'  epsilon:',num2str(params.epsilon),'  exp_decay:',num2str(params.exp_decay)])


