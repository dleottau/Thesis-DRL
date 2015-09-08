% function f = optimizationFunction(x0)
% 
% global RUNS;

clc
clf
clear all
close all
RUNS=4;
if matlabpool('size') == 0 % checking to see if my pool is already open
    matlabpool(RUNS)
else
    matlabpool close
    matlabpool(RUNS)
end

x0 = [];
xname{1}='alpha';
x0(1) = 0.3;
xname{2}='lambda';
x0(2) = 0.94;
xname{3}='epsilon';
x0(3) = 0.04;  
xname{4}='k-lenient';
x0(4) = 3;  
xname{5}='beta';
x0(5) = 0.75; 
xname{6}='DRL'; 
x0(6)= 0;  % 0 for CRL, 1 for DRL, 2 for DRL with joint states
xname{7}='MAapproach';
x0(7) = 0;   % 0 no cordination, 1 frequency adjusted, 2 leninet




[cumR, itae] = MC3D_run(x0,RUNS);
f=-cumR;
%f=itae;

%disp(['ITAE:',num2str(itae), '; cumRew:',num2str(cumR),'; coresX:',num2str(x0(1)),'; coresV:',num2str(x0(2)),'; stdDiv:',num2str(x0(3))]);
disp(['cumRew:',num2str(cumR), '; ITAE:',num2str(itae),'; alpha:',num2str(x0(1)),'; lambda:',num2str(x0(2)),'; epsilon:',num2str(x0(3))]);
%disp(['cumRew:',num2str(cumR), '; ITAE:',num2str(itae),'; k:',num2str(x0(1)),'; beta:',num2str(x0(2)),'; alpha:',num2str(x0(3)),'; lambda:',num2str(x0(4)),'; epsilon:',num2str(x0(5))]);

%disp(['ITAE:',num2str(itae), '; cumRew:',num2str(cumR),'; alpha:',num2str(x(1)),'; lambda:',num2str(x0(2)),'; epsilon:',num2str(x(3))])


