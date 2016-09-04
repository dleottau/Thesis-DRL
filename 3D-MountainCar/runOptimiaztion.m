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
xname{1}='pDec';
x0(1)  = 0.9;  % factor to decay transfer knowledge probability
xname{2}='scale1-';
x0(2)  = 1.0;  % nash scalization
xname{3}='scale2-';
x0(3)  = 1.0;  % nash scalization

options = hilloptions('TimeLimit', 600);
options.step = [0.05; 0.25; 0.25];
options.space = [[0.2; 0.5; 0.5], [0.99; 2; 2]];
options.peaks = 4;
options.oneDimPerTry = 1;


[x,fval]=hillDLF(@optimizationFunction,x0,options);
x
fval

matlabpool close;
toc

% 
% 
% clc
% clf
% clear all
% close all
% xname{1}='alpha';
% x(1) = 0.15;   % learning rate
% xname{2}='lambda';
% x(2) = 0.8;   % lambda
% xname{3}='epsilon';
% x(3)  = 0.08;  % epsilon
% RUNS=1;
% 
% fitness = MC3D_run(x,RUNS);
% f=-fitness;
% 
% 
% for i=1:length(x)
