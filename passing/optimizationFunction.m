% function f = optimizationFunction(x)
% global RUNS;
% global opti;
% global test;

clc
clf
%clear all
close all
tic

global opti;
opti = 0;

if ~opti
    % RUNS = 25;
    RUNS = 1;
    %     myCluster = parcluster('local');
    %     if isempty(gcp('nocreate')) == 0        % checking to see if my pool is already open
    %         parpool('local',myCluster.NumWorkers)
    %     else
    %         delete(gcp)
    %         parpool('local',myCluster.NumWorkers)
    %     end
end

x0 = [];

%% Algorithm parameters.-

xname{1} = 'alpha';
x0(1)    = 0.2;

xname{2} = 'softmax';
x0(2)    = 11;

xname{3} = 'decay';
x0(3)    = 8;

xname{4} = 'lambda';
x0(4)    = 0.95;

xname{5} = 'beta';
x0(5)    = 0.9;

xname{6} = 'MAapproach';
x0(6)    = 0;   % 0 no cordination, 1 frequency adjusted, 2 lenient

xname{7} = 'k-lenient';
x0(7)    = 1.5;

xname{8} = 'Transfer';
x0(8)    = 1;   %=1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies

xname{9} = 'NeASh';
x0(9)    = 1;   % 0 COntrol sharing, 1 NASh

%%
if opti
    x0(1) = x(1);
    x0(2) = x(2);
    x0(3) = x(3);
    x0(4) = x(4);
end

stringName = [];

for i = length(x0) : -1 : 1
    stringName = [stringName '; ' xname{i} num2str(x0(i)) ];
end
stringName = [stringName(3:end) '; ' num2str(RUNS) 'RUNS'];

disp('-');
disp(stringName);
disp('-');

%% Se ejecuta RUN_SCRIPT.-
[cumGoals] = RUN_SCRIPT(x0,RUNS,stringName);

f = cumGoals;

if ~opti
    disp('-');
    disp(['cumGoals:',num2str(cumGoals)]);
    disp('-');
    % delete(gcp)
    toc
else
    disp(['cumGoals:',num2str(cumGoals), '; Decay:',num2str(x0(1)),'; SoftmaxT:',num2str(x0(2)),'; alpha:',num2str(x0(3))]);
    %disp(['cumGoals:',num2str(cumGoals), '; Nactions:',num2str(x0(1)),'; AlphaW:',num2str(x0(2)) ]);
end