clc
clf
clear all
close all

tic
global RUNS;
RUNS=8;

global flagFirst;
flagFirst=true;
global opti;
opti=1;

myCluster = parcluster('local');
myCluster.NumWorkers = 4;  % 'Modified' property now TRUE
saveProfile(myCluster);
%if matlabpool('size') == 0 % checking to see if my pool is already open
    parpool(myCluster.NumWorkers)
%else
 %   matlabpool close
 %   matlabpool(myCluster.NumWorkers)
% myCluster = parcluster('local');
%myCluster.NumWorkers = 2;  % 'Modified' property now TRUE
% saveProfile(myCluster);    % 'local' profile now updated, 'Modified' property now FALSE 
%end

x0 = [];

xname{1}='softmaxX';
x0(1)  = 0.5;  % epsilon
xname{2}='softmaxW';
x0(2)  = 1;  % epsilon
xname{3}='decayX';
x0(3) = 15;   % exploration decay
xname{4}='decayW';
x0(4) = 10;   % exploration decay
xname{5}='alpha';
x0(5) = 0.3;   % learning rate

%----------  

options = hilloptions('TimeLimit', 600);
options.step = [0.1; 0.5; 1; 1; 0.1];
options.space = [[0.1; 0.5; 2; 2; 0.1], [1; 10; 20; 20; 0.9]];
options.peaks = 4;
options.oneDimPerTry = 1;


[x,fval]=hillDLF(@optimizationFunction,x0,options);
x
fval

%matlabpool close;
toc


