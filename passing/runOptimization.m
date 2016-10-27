clc
clf
clear all
close all

tic
global RUNS;
RUNS = 8;

global flagFirst;
flagFirst = true;
global opti;
opti = 1;
global prueba;
prueba = 0;
global test;
test = 0;

myCluster            = parcluster('local');
myCluster.NumWorkers = 4;
parpool('local',myCluster.NumWorkers)
% -------------------------------------------------------------------------

x0 = [];

xname{1} = 'decay';
x0(1)    = 13;               % Exploration decay
xname{2} = 'aScale';
x0(2)    = 9;
%------------------------------------------

options = hilloptions('TimeLimit', 600);

options.step         = [1; 1];
options.space        = [[2; 1], [18; 20]];
options.peaks        = 4;
options.oneDimPerTry = 1;

[x,fval] = hillDLF(@optimizationFunction,x0,options);

x
fval

% matlabpool close
delete(gcp)
toc