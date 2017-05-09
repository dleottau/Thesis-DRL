function PLOTS()

% clear all
% close all
% clc

addpath('Opti')

% keyboard

spot     = {':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot = {'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW    = [3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1];
% lineW    = [2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1];

legendN  = [];

K    = 10;  % # points ploted for errobar
%span = 0.00001;
% span = 0.07;

n = 1;
M = [];
S = [];

%----------
% %folder = 'Opti/cosh/hq/';
% folder = 'Opti/neash/';
% %folder = 'tests/';
% files = dir(fullfile([folder '*.mat']));
% 
% for i=1:size(files,1)
%     results=importdata([folder files(i).name]);
%     [M,S,n,legendN] = load_results(results,M,S,n,legendN,files(i).name);
% end
%----------

% ----------------------------
load 'Opti/neash/ScaleNeash29; Controller0; Transfer1; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay14; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Src1 scaleNeash25; decay29'); %Fitness=57.1413; T_th=976

%load 'Opti/neash/ScaleNeash25; Controller0; Transfer1; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay29; 8RUNS.mat';
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Src1 scaleNeash25; decay29'); %Fitness=57.1413; T_th=976

load 'Opti/neash/ScaleNeash15; Controller1; Transfer1; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay14; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Src2 scaleNeash15; decay14'); %T_th=956; Fitness=57.3516

%load 'Opti/neash/ScaleNeash17; Controller1; Transfer1; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay8; 8RUNS.mat';
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Src2 scaleNeash17; decay8'); %T_th=956; Fitness=57.3516

% 
load 'Opti/cosh/hq/ScaleNeash0; Controller0; Transfer1; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay19; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Src1 cosh; decay19'); %Fitness=57.0439; T_th=947
% 
load 'Opti/cosh/lq/ScaleNeash0; Controller1; Transfer1; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay14; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Src2 cosh; decay14'); %T_th=1209; Fitness=55.0285
% 
load 'Opti/DRL/Fr5/Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay15; 8RUNS.mat'
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Ind decay15');
% ----------------------------

Ms = M;     % Smoothed means
Ss = S;     % Smoothed stdevs

for i = 1:size(M,3)
    for j = 1:size(M,2)
        %Ms(:,j,i) = smooth( M(:,j,i), span,'rloess');
        %Ss(:,j,i) = smooth( S(:,j,i), span,'rloess');
        %sR(:,i) = std(M(:,:,i),0,2);
        Ms(:,j,i) = M(:,j,i); % no smooth
        Ss(:,j,i) = S(:,j,i);
    end
end

E  = size(M,1);
L  = floor(E/K);
MK = zeros(K-1,size(M,2),size(M,3));
SK = MK;

for k = 1:K-1
    for i = 1:size(M,3)
        for j = 1:size(M,2)
            s         = round(k*L + (j-1)*L/(2*size(M,2)));
            x(k,j)    = s;
            MK(k,j,i) = Ms(s,j,i);
            SK(k,j,i) = Ss(s,j,i);
        end
    end
end

figure

% subplot(3,1,1);
% subplot(2,1,1);
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on

for j = 1:size(M,2)
    pt(j) = plot(Ms(:,j,1), spot{j}, 'LineWidth',lineW(j));
    errorbar(x(:,j) ,MK(:,j,1),SK(:,j,1), spot_dot{j});
end
hold
axis([1 E 0 100])

grid on
ylabel('% of Ball-Target distance');
xlabel('Episodes');
legend(pt,legendN);
%saveas(gcf,[folder 'CRLvsDRL.fig'])

rmpath('Opti')
end

function [M, S, n, legendN] = load_results(results, M, S, n, legendN, leg)

% N = size(results.mean_dbt,2);
% M(:,n,1) = results.mean_dbt';
% S(:,n,1) = results.std_dbt'/sqrt(N);  % Computing standard error

N = size(results.mean_goals,2);
M(:,n,1) = results.mean_goals';
S(:,n,1) = results.std_goals'/sqrt(N);  % Computing standard error

legendN{n} = leg;
n          = n+1;
end