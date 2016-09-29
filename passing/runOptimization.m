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
desired_Cluster.NumWorkers = 5;
matlabpool('open',desired_Cluster.NumWorkers);
% -------------------------------------------------------------------------

x0 = [];

xname{1} = 'softmax';
x0(1)    = 5;              % Epsilon
xname{2} = 'decay';
x0(2)    = 2;               % Exploration decay
xname{3} = 'aScale';
x0(3)    = 9;

%------------------------------------------

options = hilloptions('TimeLimit', 600);

options.step         = [10; 1; 5];
options.space        = [[1; 2; 5], [80; 16; 30]];
options.peaks        = 4;
options.oneDimPerTry = 1;

[x,fval] = hillDLF(@optimizationFunction,x0,options);

x
fval

matlabpool close
% delete(gcp)
toc