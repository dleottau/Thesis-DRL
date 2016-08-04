% function fitness = optimizationFunction(x)
% global RUNS;
% global opti;

clc
clf
clear all
close all
tic
global opti;
opti=0;
RUNS=10;

x0 = [];
xname{1}='alpha';
x0(1) = 0.1;   % learning rate
xname{2}='lambda';
x0(2) = 0.9;   % lambda
xname{3}='epsilon';
x0(3)  = 0.03;  % epsilon
xname{4}='x.nCores';
x0(4)=11; %cfg.nCores x position
xname{5}='vx.nCores';
x0(5)=7; %cfg.nCores x speed

if opti
    x0(1) = x(1);
    x0(2) = x(2);
    x0(3) = x(3);
    x0(4) = x(4);
    x0(5) = x(5);
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

%parfor n=1:RUNS
for n=1:RUNS
    episodes=200;
    cumR(n) = MountainCarDemo(episodes,x0,n);
end

fitness = mean(cumR);


if ~opti
    disp('-');
    disp(['Fitness:',num2str(fitness)]);
    disp('-');
    toc
    %matlabpool close;
else
    disp(['Fitness:',num2str(fitness), '; ' stringName]);
    
end

%disp(['Fitness:',num2str(fitness),'; alpha:',num2str(params.alpha),'; gamma:',num2str(params.gamma),'; lambda:',num2str(params.lambda),'; epsilon:',num2str(params.epsilon),'; exp_decay:',num2str(params.exp_decay)])
%disp(['Fitness: ',num2str(fitness),'  cores_X:',num2str(x0(1)),'; coresVx:',num2str(x0(2))])


