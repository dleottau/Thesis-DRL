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
global test;
test=0;

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
xname{1}='alpha';
x0(1) = 0.5;
xname{2}='softmax';
x0(2) = 70;
xname{3}='decay';
x0(3) = 8;
xname{4}='lambda';
x0(4) = 0.9;  

% xname{4}='k-lenient';
% x0(4) = 1.5;  
% xname{5}='beta';
% x0(5) = 0.9;

%----------  

options = hilloptions('TimeLimit', 600);
% options.step = [0.1; 10; 1; 0.5; 0.1];
% options.space = [[0.1; 1; 5; 0.5; 0.4], [0.7; 80; 15; 5; 0.99]];
options.step = [0.1; 10; 1; 0.1;];
options.space = [[0.1; 1; 5; 0.1;], [0.7; 80; 15; 0.99]];
options.peaks = 4;
options.oneDimPerTry = 1;

[x,fval]=hillDLF(@optimizationFunction,x0,options);
x
fval

%matlabpool close;
toc
