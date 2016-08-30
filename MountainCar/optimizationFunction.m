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
RUNS=25;

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
xname{6}='transfer';
x0(6)  = 2;  % flag for trasferring: {0 no-transfer; 1 cosh; 2 nash;  }
xname{7}='pDec';
x0(7)  = 0.6;  % factor to decay transfer knowledge probability
xname{8}='scale1-';
x0(8)  = 1.5;  % nash scalization
xname{9}='scale2-';
x0(9)  = 1.5;  % nash scalization

if opti
%     x0(1) = x(1);
%     x0(2) = x(2);
%     x0(3) = x(3);
%     x0(4) = x(4);
%     x0(5) = x(5);
    x0(7) = x(1);
    x0(8) = x(2);
    x0(9) = x(3);
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

episodes=200;
cumR=zeros(RUNS,episodes);

%parfor n=1:RUNS
for n=1:RUNS
    cumR(n,:) = MountainCarDemo(episodes,x0,n);
end

perf=0.5;
if opti
    perf=0.0001;
end
f = abs(mean(cumR(:,ceil(episodes*perf):end)));
fitness = mean(f);

if ~opti
    plot(mean(cumR))      
    drawnow;
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


