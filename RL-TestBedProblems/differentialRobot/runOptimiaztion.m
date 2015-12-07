clc
clf
clear all
close all

tic
global RUNS;
RUNS=25;

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

xname{1}='k-leninet';
x0(1) = 1.0;   %

xname{2}='beta';
x0(2) = 0.7;   % 

%xname{3}='decay';
%x0(3) = 8;   % exploration decay

xname{3}='alpha';
x0(3) = 0.3;   % learning rate

% xname{2}='softmax';
% x0(2)  = 2;  % epsilon


%----------  

options = hilloptions('TimeLimit', 600);
%options.step = [1; 0.1];
%options.space = [[2; 0.1], [15; 0.6]];
options.step = [0.5; 0.1; 0.1];
options.space = [[0.5; 0.4; 0.1], [5; 0.99; 0.7]];
options.peaks = 2;
options.oneDimPerTry = 1;


[x,fval]=hillDLF(@optimizationFunction,x0,options);
x
fval

matlabpool close;
toc


