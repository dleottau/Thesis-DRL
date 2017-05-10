clc
clf
clear all
close all

tic
global RUNS;
RUNS = 2;

global flagFirst;
flagFirst = true;
global opti;
opti = 1;
global prueba;
prueba = 0;
global test;
test = 0;

myCluster = parcluster('local');
myCluster.NumWorkers = 2;  % 'Modified' property now TRUE
saveProfile(myCluster);    % 'local' profile now updated, 'Modified' property now FALSE
if isempty(gcp('nocreate')) == 0        % checking to see if my pool is already open
    parpool('local',myCluster.NumWorkers)
else
    delete(gcp)
    parpool('local',myCluster.NumWorkers)
end

% -------------------------------------------------------------------------

x0 = [];

xname{1} = 'softmax';
x0(1)    = 20;
xname{2} = 'decay';
x0(2)    = 20;
%xname{2} = 'scaleNeash';
%x0(2)    = 16;                 % Friction coefficient

%------------------------------------------

options = hilloptions('TimeLimit', 600);

options.step         = [5; 3];
options.space        = [[1 ; 6], [50; 39]];
options.peaks        = 4;
options.oneDimPerTry = 1;

[x,fval] = hillDLF(@optimizationFunction,x0,options);

x
fval

% matlabpool close
delete(gcp)
toc