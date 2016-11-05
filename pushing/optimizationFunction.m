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
global finalTest;
finalTest=1;

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

xname{1}='softmaxX'; % or "k-leninet"
x0(1)  = 3;  % 
xname{2}='decayX'; % exploration decay or "beta lenient decay"
x0(2) = 8;   

xname{3}='alpha';
x0(3) = 0.3;   % learning rate

xname{4}='k-leninet';
x0(4) = x0(1);   %
xname{5}='beta';
x0(5) = x0(2);   %

xname{6}='lambda';
x0(6) = 0.9;   % lambda
xname{7}='DRL'; 
x0(7) = 1;  % 0 for CRL, 1 for DRL
xname{8}='jointState'; 
x0(8) = 0; % Selects joint state(1) or individual states spaces per agent(0).
xname{9}='MAapproach'; 
x0(9) = 0; % MAapproach, 0 DRL, 1 CAdec, 2 Lenient, 3 CAdec ;

xname{10}='softmaxW'; % or "k-leninet"
x0(10)  = 3;  % 
xname{11}='decayW'; % exploration decay or "beta lenient decay"
x0(11) = 8;   

if opti
    x0(1) = x(1);
    x0(10) = x(2);
    x0(2) = x(3);
    x0(11) = x(4);
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
    toc
    %matlabpool close;
else
    disp(['cumGoals:',num2str(cumGoals), '; ' stringName]);
    
end
