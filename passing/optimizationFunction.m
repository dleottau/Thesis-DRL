<<<<<<< HEAD
% function f = optimizationFunction(x)
% global RUNS;
% global opti;
% global test;

clc
clf
%clear all
close all
tic

=======
function f = optimizationFunction(x)
global RUNS;
>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb
global opti;
global prueba;

% clc
% clf
% clear all
% close all
% tic
% 
% global opti;
% opti = 0;
% global test;
% test=0;
% global prueba;
% prueba = 1;

if ~opti
<<<<<<< HEAD
    % RUNS = 25;
    RUNS = 1;
    %     myCluster = parcluster('local');
    %     if isempty(gcp('nocreate')) == 0        % checking to see if my pool is already open
    %         parpool('local',myCluster.NumWorkers)
    %     else
    %         delete(gcp)
    %         parpool('local',myCluster.NumWorkers)
    %     end
=======
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
>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb
end

x0 = [];

%% Algorithm parameters.-

<<<<<<< HEAD
xname{1} = 'alpha';
x0(1)    = 0.2;

xname{2} = 'softmax';
x0(2)    = 11;

xname{3} = 'decay';
x0(3)    = 8;

xname{4} = 'lambda';
x0(4)    = 0.95;

xname{5} = 'beta';
x0(5)    = 0.9;

xname{6} = 'MAapproach';
x0(6)    = 0;   % 0 no cordination, 1 frequency adjusted, 2 lenient

xname{7} = 'k-lenient';
x0(7)    = 1.5;

xname{8} = 'Transfer';
x0(8)    = 1;   %=1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies

xname{9} = 'NeASh';
x0(9)    = 1;   % 0 COntrol sharing, 1 NASh
=======
xname{1}  = 'alpha';
x0(1)     = 0.2;

xname{2}  = 'softmax';
x0(2)     = 8;              % 11

xname{3}  = 'decay';
x0(3)     = 4;              % 8

xname{4}  = 'lambda';
x0(4)     = 0.95;

xname{5}  = 'beta';
x0(5)     = 0.9;

xname{6}  = 'MAapproach';
x0(6)     = 0;      % 0 no cordination, 1 frequency adjusted, 2 lenient

xname{7}  = 'k-lenient';
x0(7)     = 1.5;

xname{8}  = 'Transfer';
x0(8)     = 0;      % =1 transfer, >1 acts gready from source policy, =0 learns from scratch, =-1 just for test performance from stored policies

xname{9}  = 'NeASh';
x0(9)     = 0;      % 0 COntrol sharing, 1 NASh

xname{10} = 'ScaleNeash';
x0(10)    = 9;             % 20    % 0.04 scale factor for the action space in neash

% -------------------------------------------------------------------------
>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb

if opti
<<<<<<< HEAD
    x0(1) = x(1);
    x0(2) = x(2);
    x0(3) = x(3);
    x0(4) = x(4);
=======
    x0(2)  = x(1);
    x0(3)  = x(2);
    %x0(10) = x(3);    
    x0(1) = x(3);    
>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb
end

stringName = [];

for i = length(x0) : -1 : 1
    stringName = [stringName '; ' xname{i} num2str(x0(i)) ];
end
stringName = [stringName(3:end) '; ' num2str(RUNS) 'RUNS'];

disp('-');
disp(stringName);
disp('-');

%% Se ejecuta RUN_SCRIPT.-
<<<<<<< HEAD
[cumGoals] = RUN_SCRIPT(x0,RUNS,stringName);

f = cumGoals;
=======
[f] = RUN_SCRIPT(x0,RUNS,stringName);

>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb

if ~opti
    disp('-');
    disp(['%Distance BT: ',num2str(f)]);
    disp('-');
    % delete(gcp)
    toc
else
    disp(['%Distance BT: ',num2str(f), '; ', stringName]);
    %disp(['%Distance BT: ',num2str(f), '; Time_th: ',num2str(tth), '; ' stringName]);
end

