clc
clf
clear all
close all

tic
global RUNS;
RUNS=1;

global flagFirst;
flagFirst=true;
global opti;
opti=1;

myCluster = parcluster('local');
if matlabpool('size') == 0 % checking to see if my pool is already open
    matlabpool(myCluster.NumWorkers)
else
    matlabpool close
    matlabpool(myCluster.NumWorkers)
% myCluster = parcluster('local');
% myCluster.NumWorkers = 4;  % 'Modified' property now TRUE
% saveProfile(myCluster);    % 'local' profile now updated, 'Modified' property now FALSE 
end

x0 = [];
% xname{1}='Nactions';
% x0(1) = 7;   % learning rate
% xname{2}='alpha';
% x0(2) = 0.5;   % learning rate

xname{1}='decay';
x0(1) = 9;   % exploration decay
xname{2}='softmax';
x0(2)  = 1;  % epsilon
xname{3}='alpha';
x0(3) = 0.3;   % learning rate
xname{4}='gain';
x0(4) = 200000;   % reward function gain
xname{5}='var';
x0(5) = 30;   % reward function variance


%----------  

options = hilloptions('TimeLimit', 600);
%options.step = [1; 0.1];
%options.space = [[2; 0.1], [15; 0.6]];
options.step = [1; 0.5; 0.1; 50000; 10];
options.space = [[0; 0.1; 0.1; 100000; 10], [15; 5; 0.7; 400000; 60]];
options.peaks = 2;
options.oneDimPerTry = 1;


[x,fval]=hillDLF(@optimizationFunction,x0,options);
x
fval

matlabpool close;
toc


