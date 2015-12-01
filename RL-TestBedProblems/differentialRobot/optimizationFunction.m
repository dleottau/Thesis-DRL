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

%     myCluster = parcluster('local');
%     if matlabpool('size') == 0 % checking to see if my pool is already open
%         matlabpool(myCluster.NumWorkers)
%     else
%         matlabpool close
%         matlabpool(myCluster.NumWorkers)
%     end
end

x0 = [];

xname{1}='k-leninet';
x0(1) = 1;   %

xname{2}='beta';
x0(2) = 0.7;   % 

xname{3}='decay';
x0(3) = 8;   % exploration decay

xname{4}='alpha';
x0(4) = 0.3;   % learning rate

xname{5}='softmax';
x0(5)  = 2;  % epsilon

% xname{1}='decay';
% x0(1) = 8;   % exploration decay
% 
% xname{2}='softmax';
% x0(2)  = 2;  % epsilon
% 
% xname{3}='alpha';
% x0(3) = 0.3;   % learning rate
% 
% xname{4}='k-leninet';
% x0(4) = 1.5;   %
% 
% xname{5}='beta';
% x0(5) = 0.9;   % 

xname{6}='lambda';
x0(6) = 0.95;   % lambda

xname{7}='DRL'; 
x0(7) = 1;  % 0 for CRL, 1 for DRL

xname{8}='MAapproach'; 
x0(8) = 2; % MAapproach, 0 DRL, 1 FA, 2 Lenient ;

if opti
    x0(1) = x(1);
    x0(2) = x(2);
    x0(3) = x(3);
    x0(4) = x(4);
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
    %disp(['cumGoals:',num2str(cumGoals), '; Decay:',num2str(x0(1)),'; SoftmaxT:',num2str(x0(2)),'; alpha:',num2str(x0(3)),'; k-lenient:',num2str(x0(4)),'; beta:',num2str(x0(5))]);
    disp(['cumGoals:',num2str(cumGoals), '; ' stringName]);
    
end
