clc
clf
clear all
close all

tic
global RUNS;
<<<<<<< HEAD
RUNS = 10;
=======
RUNS = 8;
>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb

global flagFirst;
flagFirst = true;
global opti;
opti = 1;
<<<<<<< HEAD
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

=======
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
%desired_Cluster = parcluster('local');
%desired_Cluster.NumWorkers = 4;
%matlabpool('open',desired_Cluster.NumWorkers);
% -------------------------------------------------------------------------

x0 = [];

xname{1} = 'softmax';
x0(1)    = 8;              % Epsilon
xname{2} = 'decay';
x0(2)    = 5;               % Exploration decay
% xname{3} = 'aScale';
% x0(3)    = 9;
xname{3} = 'alpha';
x0(3)    = 0.2;
>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb
%------------------------------------------

options = hilloptions('TimeLimit', 600);

<<<<<<< HEAD
options.step         = [0.1; 10; 1; 0.1;];
options.space        = [[0.1; 1; 5; 0.1;], [0.7; 80; 15; 0.99]];
=======
% options.step         = [10; 1; 5];
% options.space        = [[1; 2; 5], [80; 16; 30]];
options.step         = [1; 1; 0.1];
options.space        = [[1; 2; 0.1], [20; 16; 0.6]];
>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb
options.peaks        = 4;
options.oneDimPerTry = 1;

[x,fval] = hillDLF(@optimizationFunction,x0,options);
<<<<<<< HEAD
x
fval

delete(gcp)
=======

x
fval

matlabpool close
% delete(gcp)
>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb
toc