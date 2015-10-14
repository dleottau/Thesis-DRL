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

xname{1}='decay';
x0(1) = 10;   % exploration decay

xname{2}='softmax';
x0(2)  = 1.1;  % epsilon

xname{3}='alpha';
x0(3) = 0.4;   % learning rate

xname{4}='lambda';
x0(4) = 0.95;   % lambda

xname{5}='DRL'; 
x0(5) = 1;  % 0 for CRL, 1 for DRL

xname{6}='MAapproach'; 
x0(6) = 1; % MAapproach, 0 DRL, 1 FA, 2 Lenient ;

if opti
    x0(1) = x(1);
    x0(2) = x(2);
    x0(3) = x(3);
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
    disp(['cumGoals:',num2str(cumGoals), '; Decay:',num2str(x0(1)),'; SoftmaxT:',num2str(x0(2)),'; alpha:',num2str(x0(3))]);
    %disp(['cumGoals:',num2str(cumGoals), '; Nactions:',num2str(x0(1)),'; AlphaW:',num2str(x0(2)) ]);
end
