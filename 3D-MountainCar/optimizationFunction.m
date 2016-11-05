function f = optimizationFunction(x)
global RUNS;
global opti;

% clc
% clf
% clear all
% close all
% tic
% global opti;
% opti=0;

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

xname{1}='alpha';
x0(1) = 0.20;
xname{2}='lambda';
x0(2) = 0.95;
xname{3}='epsilon';
x0(3) = 0.03;  
xname{4}='k-lenient';
x0(4) = 3.5;  
xname{5}='beta';
x0(5) = 0.8; 
xname{6}='DRL'; 
x0(6)= 3;  % 0 for CRL, 1 for DRL, 2 for DRL with joint states
xname{7}='MAapproach-Inc';
x0(7) = 0;   % 0 no cordination, 1 frequency adjusted, 2 leninet
xname{8}='5actions';
x0(8) = 0; % enable original proposal which uses 5 actions instead of 9
xname{9}='transfer';
x0(9)  = 0;  % flag for trasferring: {0 no-transfer; 1 cosh; 2 nash;  }
xname{10}='pDec';
x0(10)  = 0.5;  % factor to decay transfer knowledge probability
xname{11}='scale1-';
x0(11)  = 1.0;  % nash scalization
xname{12}='scale2-';
x0(12)  = 0.5;  % nash scalization

if opti
    x0(3) = x(1);
    x0(1) = x(2);
    x0(2) = x(3);
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


[cumR, itae] = MC3D_run(x0,RUNS,stringName);
f=-cumR;
%f=itae;

if ~opti
    disp('-');
    disp(['cumRew:',num2str(cumR), '; ITAE:',num2str(itae)]);
    disp('-');
    toc
    matlabpool close;
else
    disp(['cumRew:',num2str(cumR), '; ITAE:',num2str(itae), '; ' stringName]);
end
