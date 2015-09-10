clc
clf
clear all
close all

%dbstop in GetBestAction.m at 19;
%dbstop in Episode.m if isnan(sum(sum(RL.Q)))
%dbstop in Episode.m at 53 if isnan(sum(sum(RL.Q)))
%dbstop if error
dbstop in UpdateSARSA.m at 36
%dbstop if naninf;

tic
global RUNS;
RUNS=4;

global flagFirst;
flagFirst=true;

if matlabpool('size') == 0 % checking to see if my pool is already open
    matlabpool(RUNS)
else
    matlabpool close
    matlabpool(RUNS)
% myCluster = parcluster('local');
% myCluster.NumWorkers = 4;  % 'Modified' property now TRUE
% saveProfile(myCluster);    % 'local' profile now updated, 'Modified' property now FALSE 
end

x0 = [];
xname{1}='alpha';
x0(1) = 0.15;   % learning rate
xname{2}='lambda';
x0(2) = 0.95;   % lambda
xname{3}='epsilon';
x0(3)  = 0.1;  % epsilon

%----------  

options = hilloptions('TimeLimit', 600);
options.step = [0.05; 0.05; 0.025];
options.space = [[0.05; 0.5; 0], [0.5; 0.99; 0.3]];
%options.step = [0.5; 0.05; 0.05; 0.05; 0.02];
%options.space = [[0.5; 0.5; 0.05; 0.5; 0], [4; 0.99; 0.5; 0.99; 0.2]];
options.peaks = 2;
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
