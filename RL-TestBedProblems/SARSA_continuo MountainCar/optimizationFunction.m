function f = optimizationFunction(x0)

global RUNS;

% clc
% clf
% clear all
% close all
% RUNS=1;
% % if matlabpool('size') == 0 % checking to see if my pool is already open
% %     matlabpool(RUNS)
% % else
% %     matlabpool close
% %     matlabpool(RUNS)
% % end
% 
% x0 = [];
% xname{1}='coresX';
% x0(1) = 8;
% xname{2}='coresV';
% x0(2) = 5;
% xname{3}='stdDiv';
% x0(3) = 0.5;   % learning rate
% % xname{4}='lambda';
% % x0(4) = 0.95;   % lambda
% % xname{5}='epsilon';
% % x0(5)  = 0.05;  % epsilon


[cumR, itae] = MC3D_run(x0,RUNS);
f=-cumR;
%f=itae;

%disp(['ITAE:',num2str(itae), '; cumRew:',num2str(cumR),'; coresX:',num2str(x0(1)),'; coresV:',num2str(x0(2)),'; stdDiv:',num2str(x0(3))]);
%disp(['cumRew:',num2str(cumR), '; ITAE:',num2str(itae),'; alpha:',num2str(x0(1)),'; lambda:',num2str(x0(2)),'; epsilon:',num2str(x0(3))]);
disp(['cumRew:',num2str(cumR), '; ITAE:',num2str(itae),'; k:',num2str(x0(1)),'; beta:',num2str(x0(2)),'; alpha:',num2str(x0(3)),'; lambda:',num2str(x0(4)),'; epsilon:',num2str(x0(5))]);

%disp(['ITAE:',num2str(itae), '; cumRew:',num2str(cumR),'; alpha:',num2str(x(1)),'; lambda:',num2str(x0(2)),'; epsilon:',num2str(x(3))])


