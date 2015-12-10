clc
clf
clear all
close all

tic
global RUNS;
RUNS=8;

%global flagFirst;
%flagFirst=true;
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

xname{1}='alpha';
x0(1)=0.3;    % 0.3 Learning rate
xname{2}='epsilon';
x0(2)=0.01;   % 0.01 probability of a random action selection
xname{3}='lenientGain';
x0(3)=1.5;   %1.5 lenience parameter
xname{4}='lenientBeta';
x0(4)=0.8;   %0.9 lenience discount factor

% xname{1}='softmax';
% x0(1)=10;   % Boltzmann temperature. if <= 0 e-greaddy

%----------  

options = hilloptions('TimeLimit', 600);
%options.step = [10; 0.5; 0.1; 0.1; 0.01];
%options.space = [[0; 0.5; 0.4; 0.1; 0;], [80; 4; 0.99; 0.7; 0.1]];
options.step = [0.1; 0.01; 0.5; 0.1];
options.space = [[0.1; 0; 0.5; 0.4], [0.7; 0.1; 5; 0.99]];

options.peaks = 2;
options.oneDimPerTry = 1;

disp(['SCARA Robot Optimization'])

[x,fval]=hillDLF(@optimizationFunction,x0,options);
x
fval

%matlabpool close;
toc
