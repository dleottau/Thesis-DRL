clc
clf
clear all
close all
%dbstop in GetBestAction.m at 19;
%dbstop in Episode.m if isnan(sum(sum(RL.Q)))
%dbstop in Episode.m at 53 if isnan(sum(sum(RL.Q)))
%dbstop in UpdateSARSA.m at 28% if isnan(sum(sum(Q)))
%dbstop if naninf;

tic
global RUNS;
RUNS=8;
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
x0(1)  = 0.95;  % factor to decay transfer knowledge probability
xname{2}='scale1-';
x0(2)  = 1.5;  % nash scalization
xname{3}='scale2-';
x0(3)  = 1.5;  % nash scalization

options = hilloptions('TimeLimit', 600);
options.step = [0.05; 0.25; 0.25];
options.space = [[0.3; 0.5; 0.5], [0.99; 3; 3]];
options.peaks = 4;
options.oneDimPerTry = 1;


[x,fval]=hillDLF(@optimizationFunction,x0,options);
x
fval

matlabpool close;
toc


% x0 = [];
% xname{1}='alpha';
% x0(1) = 0.1;   % learning rate
% xname{2}='lambda';
% x0(2) = 0.9;   % lambda
% xname{3}='epsilon';
% x0(3)  = 0.01;  % epsilon
% xname{4}='x.nCores';
% x0(4)=7; %cfg.nCores x position
% xname{5}='vx.nCores';
% x0(5)=7; %cfg.nCores x speed
% 
% 
% options = hilloptions('TimeLimit', 600);
% options.step = [0.1; 0.1; 0.02; 1; 1];
% options.space = [[0.1; 0.5; 0.01; 2; 2], [0.5; 0.99; 0.1; 15; 12]];
% options.peaks = 4;
% options.oneDimPerTry = 1;

%----------  
%x0(1)=5; %cfg.nCores x position
%x0(2)=8; %cfg.nCores x speed
% x =
%     2.0000
%     3.0000
%     0.5000
% fval = 132.1818
%----------  
