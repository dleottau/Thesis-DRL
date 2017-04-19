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
x0(1)    = 3;
xname{2} = 'Fr';
x0(2)    = 7;                 % Friction coefficient

%------------------------------------------

options = hilloptions('TimeLimit', 600);

options.step         = [1 ; 1];
options.space        = [[3 ; 7], [15; 7]];
options.peaks        = 4;
options.oneDimPerTry = 1;

[x,fval] = hillDLF(@optimizationFunction,x0,options);

x
fval

% matlabpool close
delete(gcp)
toc