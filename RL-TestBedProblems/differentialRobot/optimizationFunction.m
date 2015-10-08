% function f = optimizationFunction(x)
% global RUNS;
% global opti;

clc
clf
clear all
close all
tic
global opti;
opti=0;

if ~opti
     RUNS=25;

    myCluster = parcluster('local');
    if matlabpool('size') == 0 % checking to see if my pool is already open
        matlabpool(myCluster.NumWorkers)
    else
        matlabpool close
        matlabpool(myCluster.NumWorkers)
    end
end


x0 = [];

xname{1}='NactionsVx';
x0(1) = 3;   % # actions

xname{2}='alpha';
x0(2) = 0.3;   % learning rate

xname{3}='decay';
x0(3) = 9;   % exploration decay

xname{4}='softmax';
x0(4)  = 1.1;  % epsilon

xname{5}='lambda';
x0(5) = 0.95;   % lambda

xname{6}='DRL'; 
x0(6)= 1;  % 0 for CRL, 1 for DRL

if opti
    x0(1) = x(1);
    x0(2) = x(2);
    %x0(3) = x(3);
    %x0(4) = x(4);
end

stringName=[];

for i=length(x0) : -1 : 1
    stringName = [stringName '; ' xname{i} num2str(x0(i)) ];
end
stringName=[stringName(3:end) '; ' num2str(RUNS) 'RUNS'];

if ~opti
    disp('-');
    disp(stringName);
    disp('-');
end

[cumGoals] = RUN_SCRIPT(x0,RUNS,stringName);
f=-cumGoals;

if ~opti
    disp('-');
    disp(['cumGoals:',num2str(cumGoals)]);
    disp('-');
    matlabpool close;
    toc
else
    %disp(['cumGoals:',num2str(cumGoals), '; Decay:',num2str(x0(1)),'; SoftmaxT:',num2str(x0(2)),'; alpha:',num2str(x0(3))]);
    disp(['cumGoals:',num2str(cumGoals), '; Nactions:',num2str(x0(1)),'; AlphaW:',num2str(x0(2)) ]);
end
