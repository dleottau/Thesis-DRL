clc
clf
clear all
close all

tic
global RUNS;
RUNS = 4;

global flagFirst;
flagFirst = true;
global opti;
opti = 1;
global prueba;
prueba = 0;
global test;
test = 0;

% myCluster = parcluster('local');
% if isempty(gcp('nocreate')) == 0        % checking to see if my pool is already open
%     parpool('local',myCluster.NumWorkers)
% else
%     delete(gcp)
%     parpool('local',myCluster.NumWorkers)
% end

% -------------------------------------------------------------------------
desired_Cluster = parcluster('local');
desired_Cluster.NumWorkers = 2;
matlabpool('open',desired_Cluster.NumWorkers);
% -------------------------------------------------------------------------

x0 = [];

xname{1} = 'decay';
x0(1)    = 6;
xname{2} = 'softmax';
x0(2)    = 3;
%------------------------------------------

options = hilloptions('TimeLimit', 600);

options.step         = [1; 1];
options.space        = [[2; 0], [15; 20]];
options.peaks        = 4;
options.oneDimPerTry = 1;

[x,fval] = hillDLF(@optimizationFunction,x0,options);

x
fval

matlabpool close
% delete(gcp)
toc