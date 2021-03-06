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

myCluster = parcluster('local');
myCluster.NumWorkers = 4;  % 'Modified' property now TRUE
saveProfile(myCluster);    % 'local' profile now updated, 'Modified' property now FALSE
if isempty(gcp('nocreate')) == 0        % checking to see if my pool is already open
     parpool('local',myCluster.NumWorkers)
 else
     delete(gcp)
     parpool('local',myCluster.NumWorkers)
end

% -------------------------------------------------------------------------

x0 = [];

xname{1} = 'decay';
x0(1)    = 10;              
xname{2} = 'aScale';
x0(2)    = 10;               % Exploration decay
% xname{3} = 'aScale';
% x0(3)    = 9;
%xname{3} = 'alpha';
%x0(3)    = 0.2;
%------------------------------------------

options = hilloptions('TimeLimit', 600);

% options.step         = [10; 1; 5];
% options.space        = [[1; 2; 5], [80; 16; 30]];
options.step         = [1; 2;];
options.space        = [[2; 1;], [20; 30;]];
options.peaks        = 4;
options.oneDimPerTry = 1;

[x,fval] = hillDLF(@optimizationFunction,x0,options);

x
fval

matlabpool close
% delete(gcp)
toc