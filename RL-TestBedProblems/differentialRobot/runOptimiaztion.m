clc
clf
clear all
close all

tic
global RUNS;
RUNS=10;

global flagFirst;
flagFirst=true;
global opti;
opti=1;

myCluster = parcluster('local');
if matlabpool('size') == 0 % checking to see if my pool is already open
    matlabpool(myCluster.NumWorkers)
else
    matlabpool close
    matlabpool(myCluster.NumWorkers)
% myCluster = parcluster('local');
% myCluster.NumWorkers = 4;  % 'Modified' property now TRUE
% saveProfile(myCluster);    % 'local' profile now updated, 'Modified' property now FALSE 
end

x0 = [];
xname{1}='decay';
x0(1) = 4;   % exploration decay
xname{2}='alpha';
x0(2) = 0.3;   % learning rate
xname{3}='lambda';
x0(3) = 0.9;   % lambda
xname{4}='softmax';
x0(4)  = 1;  % epsilon

%----------  

options = hilloptions('TimeLimit', 600);
options.step = [1; 0.1; 0.1; 0.5];
options.space = [[3; 0.1; 0.5; 0.1], [15; 0.7; 0.99; 5]];
%options.step = [0.5; 0.05; 0.05; 0.05; 0.02];
%options.space = [[0.5; 0.5; 0.05; 0.5; 0], [4; 0.99; 0.5; 0.99; 0.2]];
options.peaks = 2;
options.oneDimPerTry = 1;


[x,fval]=hillDLF(@optimizationFunction,x0,options);
x
fval

matlabpool close;
toc


