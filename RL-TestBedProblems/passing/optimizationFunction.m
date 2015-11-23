% %% Algoritmo que ejecuta todo el código.-
% function f = optimizationFunction(x)
% global RUNS;
% global opti;

clc
clf
clear all
close all
tic
global opti;
opti = 0;

if ~opti
     RUNS = 1;
%     myCluster = parcluster('local');
%     if matlabpool('size') == 0 % checking to see if my pool is already open
%         matlabpool(myCluster.NumWorkers)
%     else
%         matlabpool close
%         matlabpool(myCluster.NumWorkers)
%     end
end

x0 = [];

%% Parámetros Algoritmo.-
xname{1} = 'decay';
% x0(1)    = 8;          % Exploration decay
x0(1)  = 10;          % Exploration decay

xname{2} = 'softmax';
x0(2)    = 1.1;         % Epsilon

xname{3} = 'alpha';
x0(3)    = 0.3;         % Learning rate

xname{4}='gain';
x0(4) = 200000;   % reward function gain

xname{5}='var';
x0(5) = 30;   % reward function variance

xname{6} = 'lambda';
x0(6)    = 0.9;         % Lambda

xname{7} = 'DRL'; 
x0(7)    = 1;           % 0 for CRL, 1 for DRL

xname{8} = 'MAapproach'; 
x0(8)    = 0;           % MAapproach, 0 DRL, 1 FA, 2 Lenient ;

%%
if opti
    x0(1) = x(1);
    x0(2) = x(2);
    x0(3) = x(3);
    x0(4) = x(4);
    x0(5) = x(5);
end

stringName = [];

for i = length(x0) : -1 : 1
    stringName = [stringName '; ' xname{i} num2str(x0(i)) ];
end
stringName = [stringName(3:end) '; ' num2str(RUNS) 'RUNS'];

if ~opti
    disp('-');
    disp(stringName);
    disp('-');
end

%% Se ejecuta RUN_SCRIPT.-
[cumGoals] = RUN_SCRIPT(x0,RUNS,stringName);
f = -cumGoals;

if ~opti
    disp('-');
    disp(['cumGoals:',num2str(cumGoals)]);
    disp('-');
%     matlabpool close;
    toc
else
    disp(['cumGoals:',num2str(cumGoals), '; Decay:',num2str(x0(1)),'; SoftmaxT:',num2str(x0(2)),'; alpha:',num2str(x0(3))]);
    %disp(['cumGoals:',num2str(cumGoals), '; Nactions:',num2str(x0(1)),'; AlphaW:',num2str(x0(2)) ]);
end