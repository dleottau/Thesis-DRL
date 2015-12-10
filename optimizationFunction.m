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
    RUNS=1;

%     myCluster = parcluster('local');
%     if matlabpool('size') == 0 % checking to see if my pool is already open
%         matlabpool(myCluster.NumWorkers)
%     else
%         matlabpool close
%         matlabpool(myCluster.NumWorkers)
%     end
end
    

x0 = [];

xname{1}='alpha';
x0(1) = 0.1;

xname{2}='softmax';
x0(2) = 21;

xname{3}='decay';
x0(3) = 8;  
% ------

xname{4}='k-lenient';
x0(4) = 1.5;  
 
xname{5}='beta';
x0(5) = 0.9; 

xname{6}='MAapproach';
x0(6) = 1;   % 0 no cordination, 1 frequency adjusted, 2 leninet



if opti
    x0(1) = x(1);
    x0(2) = x(2);
    x0(3) = x(3);
    %x0(4) = x(4);
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
    matlabpool close;
    toc
else
    %disp(['Fitness:',num2str(f),'; alpha:',num2str(x0(1)),'; softmax:',num2str(x0(2)),'; decay:',num2str(x0(3)),'; k-lenient:',num2str(x0(4)),'; beta:',num2str(x0(5))]);
    disp(['Fitness:',num2str(f),'; alpha:',num2str(x0(1)),'; softmax:',num2str(x0(2)),'; decay:',num2str(x0(3))]);
end

