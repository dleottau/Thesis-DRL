function f = optimizationFunction(x)
global RUNS;
global opti;
global prueba;

%Comentar desde ac� para optimizar
% clc
% clf
% clear all
% close all
% tic
% 
% global opti;
% opti = 0;
% global test;
% test = 0;
% global prueba;
% prueba = 1;
%Comentar hasta ac� para optimizar

if ~opti
    RUNS = 25;        
%         myCluster = parcluster('local');
%         if isempty(gcp('nocreate')) == 0        % checking to see if my pool is already open
%             parpool('local',myCluster.NumWorkers)
%         else
%             delete(gcp)
%             parpool('local',myCluster.NumWorkers)
%         end
end

if prueba
    RUNS = 1;
end

x0 = [];

%% Algorithm parameters.-

xname{1}  = 'alpha';
x0(1)     = 0.2;

xname{2}  = 'softmax';
x0(2)     = -1;              % 11

xname{3}  = 'decay';
x0(3)     = 12;              % 8

xname{4}  = 'lambda';
x0(4)     = 0.9;

xname{5}  = 'beta';
x0(5)     = 0.99;

xname{6}  = 'MAapproach';
x0(6)     = 0;              % 0 no cordination, 1 frequency adjusted, 2 lenient

xname{7}  = 'k-lenient';
x0(7)     = 5;

xname{8}  = 'Transfer';
x0(8)     = 1;              % =1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies

xname{9}  = 'Controller';
x0(9)     = 0;              % HiQ=0 or lowQ=1 Controlller

xname{10} = 'ScaleNeash';
x0(10)    = 0;             % 10    % scale factor for the action space in neash


% -------------------------------------------------------------------------

if opti
    x0(3)  = x(1);
    %x0(10) = x(2);  
end

stringName = [];

for i = length(x0) : -1 : 3
    stringName = [stringName '; ' xname{i} num2str(x0(i)) ];
end
stringName = [stringName(3:end) '; ' num2str(RUNS) 'RUNS'];

if ~opti
    disp('-');
    disp(stringName);
    disp('-');
end

%% Se ejecuta RUN_SCRIPT.-
[f] = RUN_SCRIPT(x0,RUNS,stringName);

if ~opti
    disp('-');
    disp(['%Failed Goals: ',num2str(f)]);
    disp('-');
    % delete(gcp)
    toc
else
    disp(['%Failed Goals: ',num2str(f), '; ', stringName]);
    %disp(['%Distance BT: ',num2str(f), '; Time_th: ',num2str(tth), '; ' stringName]);
end