clc
clf
clear all
close all

tic
global RUNS;
RUNS = 10;

global flagFirst;
flagFirst = true;
global opti;
opti = 1;
global test;
test = 0;

myCluster = parcluster('local');
if isempty(gcp('nocreate')) == 0        % checking to see if my pool is already open
    parpool('local',myCluster.NumWorkers)
else
    delete(gcp)
    parpool('local',myCluster.NumWorkers)
end

x0 = [];

xname{1} = 'alpha';
x0(1)    = 0.5;             % Learning rate
xname{2} = 'softmax';
x0(2)    = 70;              % Epsilon
xname{3} = 'decay';
x0(3)    = 8;               % Exploration decay
xname{4} = 'lambda';
x0(4)    = 0.9;

%------------------------------------------

options = hilloptions('TimeLimit', 600);

options.step         = [0.1; 10; 1; 0.1;];
options.space        = [[0.1; 1; 5; 0.1;], [0.7; 80; 15; 0.99]];
options.peaks        = 4;
options.oneDimPerTry = 1;

[x,fval] = hillDLF(@optimizationFunction,x0,options);
x
fval

delete(gcp)
toc