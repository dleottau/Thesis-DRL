clc
clf
clear all
close all

tic
global RUNS;
RUNS=6;

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
xname{1}='Nactions';
x0(1) = 7;   % learning rate
xname{2}='alpha';
x0(2) = 0.5;   % learning rate

% xname{1}='decay';
% x0(1) = 10;   % exploration decay
% xname{2}='softmax';
% x0(2)  = 1;  % epsilon
% xname{3}='alpha';
% x0(3) = 0.3;   % learning rate
%xname{4}='lambda';
%x0(4) = 0.9;   % lambda


%----------  

options = hilloptions('TimeLimit', 600);
options.step = [1; 0.1];
options.space = [[2; 0.1], [15; 0.6]];
%options.step = [0.5; 0.05; 0.05; 0.05; 0.02];
%options.space = [[0.5; 0.5; 0.05; 0.5; 0], [4; 0.99; 0.5; 0.99; 0.2]];
options.peaks = 2;
options.oneDimPerTry = 1;


[x,fval]=hillDLF(@optimizationFunction,x0,options);
x
fval

matlabpool close;
toc


