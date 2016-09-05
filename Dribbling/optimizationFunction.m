% function f = optimizationFunction(x)
% global RUNS;
% global opti;
% global test;


clc
clf
clear all
close all
tic
global opti;
opti=0;
global test;
test=1;



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

if test
     RUNS=1;
end


x0 = [];

xname{1}='alpha';
x0(1) = 0.3;
xname{2}='softmax';
x0(2) = 5;
xname{3}='decay';
x0(3) = 10; 
xname{4}='lambda';
x0(4) = 0.8; 
% ------
xname{6}='MAapproach';
x0(6) = 0;   % 0 no cordination, 1 frequency adjusted, 2 leninet
xname{7}='k-lenient';
x0(7) = 1.5;  
xname{5}='beta';
x0(5) = 0.9; 
xname{8}='Transfer';
x0(8) = 1;   %=1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies
xname{9}='NeASh';
x0(9) = 1;   % 0 COntrol sharing, 1 NASh
xname{10}='ScaleNeash';
x0(10) = 10;    % 0.04 scale factor for the action space in neash

if opti
    %x0(10) = x(1);
    x0(2) = x(1);
    x0(3) = x(2);
    x0(10) = x(3);
    %x0(5) = x(5);
end

stringName=[];

for i=length(x0) : -1 : 1
    stringName = [stringName '; ' xname{i} num2str(x0(i)) ];
end
stringName=stringName(3:end);

if ~opti
    disp('-');
    disp(stringName);
    disp('-');
end


[f] = RUN_SCRIPT(x0,RUNS);

if ~opti
    disp('-');
    disp(['fitness:',num2str(f)]);
    disp('-');
    toc
else
    %disp(['Fitness:',num2str(f),'; alpha:',num2str(x0(1)),'; softmax:',num2str(x0(2)),'; decay:',num2str(x0(3)),'; k-lenient:',num2str(x0(4)),'; beta:',num2str(x0(5))]);
    %disp(['Fitness:',num2str(f),'; alpha:',num2str(x0(1)),'; softmax:',num2str(x0(2)),'; decay:',num2str(x0(3)),'; lambda:',num2str(x0(4))]);
    disp(['Fitness:',num2str(f), '; ' stringName]);
end

