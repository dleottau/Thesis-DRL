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
span = 0.10;
% span = 0.00001;
% span = 0.07;

n = 1;
M = [];
S = [];

% ----------
% folder = 'Opti/Fr5/';
% files = dir(fullfile([folder '*.mat']));
% 
% for i=1:size(files,1)
%     results=importdata([folder files(i).name]);
%     [M,S,n,legendN] = load_results(results,M,S,n,legendN,files(i).name);
% end
% ----------

% ----------------------------
% load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay3; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay3');
% 
load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay4; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay4');
% 
% load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay5; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay5');
% 
%load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay6; 8RUNS.mat';
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay6');
% 
%load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay7; 8RUNS.mat';
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay7');
% 
load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay8; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay8');
% 
%load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay9; 8RUNS.mat';
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay9');
% 
load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay10; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay10');
% 
%load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay11; 8RUNS.mat';
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay11');
% 
% load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay12; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay12');
% 
load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay13; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay13');
% 
load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay14; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay14');
% 
load 'Fr5; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay15; 8RUNS.mat';
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr5; decay15');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay3; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay3');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay4; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay4');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay7; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay7');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay13; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay13');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay5; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay5');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay6; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay6');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay8; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay8');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay9; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay9');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay10; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay10');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay11; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay11');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay12; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay12');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay14; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay14');
% 
% load 'Fr6; ScaleNeash0; Controller0; Transfer0; k-lenient5; MAapproach0; beta0.99; lambda0.9; decay15; 8RUNS.mat';
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'Fr6; decay15');
% ----------------------------

Ms = M;     % Smoothed means
Ss = S;     % Smoothed stdevs

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