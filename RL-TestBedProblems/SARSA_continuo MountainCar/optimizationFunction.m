function f = optimizationFunction(x)

global RUNS;

% clc
% clf
% clear all
% close all
% tic
% 
% RUNS=24;
% 
% myCluster = parcluster('local');
% if matlabpool('size') == 0 % checking to see if my pool is already open
%     matlabpool(myCluster.NumWorkers)
% else
%     matlabpool close
%     matlabpool(myCluster.NumWorkers)
% end

x0 = [];

xname{1}='alpha';
x0(1) = x(1);% 0.25;

xname{2}='lambda';
x0(2) = x(2);%0.8;

xname{3}='epsilon';
x0(3) = x(3);%0.06;  

xname{4}='k-lenient';
x0(4) = 0;  

xname{5}='beta';
x0(5) = 0; 

xname{6}='DRL'; 
x0(6)= 1;  % 0 for CRL, 1 for DRL, 2 for DRL with joint states

xname{7}='MAapproach';
x0(7) = 1;   % 0 no cordination, 1 frequency adjusted, 2 leninet

xname{8}='5actions';
x0(8) = 0; % enable original proposal which uses 5 actions instead of 9


stringName=[];

for i=length(x0) : -1 : 1
    stringName = [stringName '; ' xname{i} num2str(x0(i)) ];
end
stringName=stringName(3:end)

[cumR, itae] = MC3D_run(x0,RUNS,stringName);
f=-cumR;
%f=itae;


%disp(['ITAE:',num2str(itae), '; cumRew:',num2str(cumR),'; coresX:',num2str(x0(1)),'; coresV:',num2str(x0(2)),'; stdDiv:',num2str(x0(3))]);
disp(['cumRew:',num2str(cumR), '; ITAE:',num2str(itae),'; alpha:',num2str(x0(1)),'; lambda:',num2str(x0(2)),'; epsilon:',num2str(x0(3))]);
%disp(['cumRew:',num2str(cumR), '; ITAE:',num2str(itae),'; k:',num2str(x0(1)),'; beta:',num2str(x0(2)),'; alpha:',num2str(x0(3)),'; lambda:',num2str(x0(4)),'; epsilon:',num2str(x0(5))]);

%disp(['ITAE:',num2str(itae), '; cumRew:',num2str(cumR),'; alpha:',num2str(x(1)),'; lambda:',num2str(x0(2)),'; epsilon:',num2str(x(3))])

matlabpool close;
toc
