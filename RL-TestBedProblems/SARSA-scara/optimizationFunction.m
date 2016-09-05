function f = optimizationFunction(x)
global RUNS;
global opti;

% clc
% clf
% clear all
% close all
% 
% %dbstop if error
% 
% tic
% global opti;
% opti=0;
% % 
% if ~opti
%      RUNS=2;
% 
% %     myCluster = parcluster('local');
% %     if matlabpool('size') == 0 % checking to see if my pool is already open
% %         matlabpool(myCluster.NumWorkers)
% %     else
% %         matlabpool close
% %         matlabpool(myCluster.NumWorkers)
% %     end
% end
    

x0 = [];

xname{1}='alpha';
x0(1)=0.3;    % 0.3 Learning rate
xname{2}='epsilon';
x0(2)=0.01;   % 0.01 probability of a random action selection
xname{3}='lenientGain';
x0(3)=3;   %1.5 lenience parameter
xname{4}='lenientBeta';
x0(4)=0.8;   %0.9 lenience discount factor
xname{5}='gamma';
x0(5)=1;      % 1 discount factor
xname{6}='MAapproach';
x0(6)=1;   % 0 no cordination, 1 frequency adjusted, 2 leninet


if opti
    x0(1) = x(1);
    x0(2) = x(2);
    x0(3) = x(3);
    x0(4) = x(4);
    %x0(5) = x(5);
    
end

stringFile=[];

for i=length(x0) : -1 : 1
    stringFile = [stringFile '; ' xname{i} num2str(x0(i)) ];
end
stringFile=stringFile(3:end);

disp('-');
disp(['SCARA Robot']);

if ~opti
    disp('-');
    disp(stringFile);
    disp('-');
end


[f] = Demo(x0,RUNS,stringFile,opti);

if ~opti
    disp('-');
    disp(['Fitness Avg:',num2str(f) '%']);
    disp('-');
    matlabpool close;
    toc
else
    disp(['Fitness:', num2str(f),'%; ',  stringFile]);
end

