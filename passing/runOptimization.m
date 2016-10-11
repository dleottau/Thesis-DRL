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
desired_Cluster.NumWorkers = 4;
matlabpool('open',desired_Cluster.NumWorkers);
% -------------------------------------------------------------------------

x0 = [];

xname{11} = 'STP1_';
x0(1)    = 4;
xname{12} = 'STP2_';
x0(2)    = 2;
xname{13} = 'STP3_';
x0(3)    = 3;
xname{14} = 'STP4_';
x0(4)    = 9;
%------------------------------------------

options = hilloptions('TimeLimit', 600);

options.step         = [1; 1; 1; 1];
options.space        = [[1; 1; 1; 1], [5; 7; 6; 9]];
options.peaks        = 4;
options.oneDimPerTry = 1;

[x,fval] = hillDLF(@optimizationFunction,x0,options);

x
fval

matlabpool close
% delete(gcp)
toc