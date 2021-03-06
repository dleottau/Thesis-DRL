function PLOTS()

% clear all
% close all
% clc

% keyboard

spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW=[2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1];

legendN  = [];

K        = 10; % # points ploted for errobar
% span     = 0.00001;
span     = 0.10;
% span = 0.07;

n = 1;
M = [];
S = [];

% ----------
% folder = 'opti/drl/test1/'; 
% files = dir(fullfile([folder '*.mat']));
% 
% for i=1:size(files,1)
%     results=importdata([folder files(i).name]);
%     [M,S,n,legendN] = load_results(results,M,S,n,legendN,files(i).name);
% end
% ----------

%load 'Opti/neash/gauss/ScaleNeash9; NeASh1; Transfer1; k-lenient5; MAapproach0; beta0.9; lambda0.95; decay7; 4RUNS.mat';
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Neash-gauss-Best');

load 'Opti/neash/gauss/ScaleNeash11; NeASh1; Transfer1; k-lenient5; MAapproach0; beta0.9; lambda0.95; decay7; 4RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Neash-gauss-Fast');

load 'Opti/neash/triang/ScaleNeash9; NeASh2; Transfer1; k-lenient5; MAapproach0; beta0.9; lambda0.95; decay7; 4RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Neash-triang-Best');

% load 'Opti/neash/triang/ScaleNeash9; NeASh2; Transfer1; k-lenient5; MAapproach0; beta0.9; lambda0.95; decay11; 4RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Neash-triang-Fast');

load 'Opti/drl/STD500; Radius500; Gain200000000; 4RUNS';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Ind-Best');
 
% load opti/drl/test1/DRL_8Runs_Noise0.01_MA0_alpha0.2_lambda0.95_softmax6_decay5.mat;
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Ind-Best2');
% 
% load opti/drl/test1/DRL_8Runs_Noise0.01_MA0_alpha0.2_lambda0.95_softmax10_decay7.mat;
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Ind-Fast1');
% 
% load opti/drl/test1/DRL_8Runs_Noise0.01_MA0_alpha0.2_lambda0.95_softmax10_decay6.mat;
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Ind-Fast2');
% 
% 
% load opti/cosh/test1/DRL_8Runs_Noise0.01_MA0_alpha0.2_lambda0.95_softmax10_decay5_CoSh.mat;
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Neash-Best1');
% 
% load opti/cosh/test1/DRL_8Runs_Noise0.01_MA0_alpha0.2_lambda0.95_softmax10_decay4_CoSh.mat;
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Neash-Fast1');
% 
% load opti/cosh/test1/DRL_8Runs_Noise0.01_MA0_alpha0.2_lambda0.95_softmax8_decay5_CoSh.mat;
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Neash-Fast2');
% 


Ms = M;%Smoothed means
Ss = S;%Smoothed stdevs

for i = 1:size(M,3)
    for j = 1:size(M,2)
        Ms(:,j,i) = smooth( M(:,j,i), span,'rloess');
        Ss(:,j,i) = smooth( S(:,j,i), span,'rloess');
        %sR(:,i) = std(M(:,:,i),0,2);
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
end

function [M, S, n, legendN] = load_results(results, M, S, n, legendN, leg)

N = size(results.mean_dbt,2);
M(:,n,1) = results.mean_dbt';
S(:,n,1) = results.std_dbt'/sqrt(N);  % Computing standard error

% N = size(results.mean_goals,2);
% M(:,n,1) = results.mean_goals';
% S(:,n,1) = results.std_goals'/sqrt(N);  % Computing standard error

legendN{n} = leg;
n          = n+1;
end