function PLOTS()

clear all
close all
clc

record=0;

spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW=[2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1];

legendN=[];

K=12; % # points ploted for errobar
span=0.00001;
%span=0.07;

n=1;
M=[];
S=[];

% ----------
% folder = 'opti/';
% files = dir(fullfile([folder '*.mat']));
% for i=1:size(files,1)
%      results=importdata([folder files(i).name]);
%      [M,S,n,legendN] = load_results(results,M,S,n,legendN,files(i).name);
% end
% ----------

folder='final/Delft/';
stringName = 'MAapproach0; DRL1; lambda0.9; softmax1; alpha0.3; decay10; beta0.7; k-leninet1; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL');

stringName = 'MAapproach0; DRL0; lambda0.9; softmax2; alpha0.5; decay7; beta0.7; k-leninet1; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'CRL');

folder='final/';

stringName = 'MAapproach0; jointState0; DRL1; lambda0.9; beta0.7; k-leninet1; alpha0.5; decay8; softmax3; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-IndivStates');

% stringName = 'decayW7; softmaxW0.5; MAapproach0; jointState0; DRL1; lambda0.9; beta9; k-leninet1; alpha0.3; decayX9; softmaxX1; 25RUNS.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-indivStates-Fast');

% stringName = 'decayW7; softmaxW0.5; MAapproach0; jointState0; DRL1; lambda0.9; beta9; k-leninet2; alpha0.3; decayX9; softmaxX2; 25RUNS.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-indepStates-Best');

% stringName = 'MAapproach0; DRL1; lambda0.9; softmax1; alpha0.3; decay10; beta0.7; k-leninet1; 25RUNS.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL2');

% stringName = 'MAapproach1; DRL1; lambda0.95; alpha0.4; softmax1.1; decay10; 25RUNS.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-CAdec');
%  
% stringName = 'MAapproach-Inc1; DRL1; lambda0.95; beta0.7; k-leninet1; alpha0.3; decay13; softmax0.5; 29RUNS.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-CAinc');
%  
% stringName = 'MAapproach2; DRL1; lambda0.95; softmax2; alpha0.3; decay8; beta0.7; k-leninet1; 25RUNS_k1_beta0.7.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Lenient');
% 
stringName = 'fuz-DRL1; lambda0.95; softmax1.1; decay9; alpha0.3; Nactions3; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Hybrid');
% 

% stringName = 'DRL0; lambda0.9; alpha0.5; softmax2; decay7; 25RUNS.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CRL1');






Ms=M;%Smoothed means
Ss=S;%Smoothed stdevs

for i=1:size(M,3)
    for j=1:size(M,2)
        Ms(:,j,i)=smooth( M(:,j,i), span,'rloess');
        Ss(:,j,i)=smooth( S(:,j,i), span,'rloess');
        %sR(:,i) = std(M(:,:,i),0,2);
    end
end    

E=size(M,1);
L=floor(E/K);
MK=zeros(K-1,size(M,2),size(M,3));
SK=MK;
for k=1:K-1
%for k=ceil(K/2):K-1
    for i=1:size(M,3)
        for j=1:size(M,2)
            s = round(k*L + (j-1)*L/(2*size(M,2)));
            x(k,j) = s;
            MK(k,j,i) = Ms(s,j,i);
            SK(k,j,i) = Ss(s,j,i);
        end
    end
end




figure
set(gca,'fontsize',16)
%subplot(3,1,1);    
%subplot(2,1,1); 
plot(x(:,1),zeros(length(x(:,1))), '.w');
hold on
for j=1:size(M,2)
    pt(j)=plot(Ms(:,j,1), spot{j}, 'LineWidth',lineW(j));
    errorbar(x(:,j) ,MK(:,j,1),SK(:,j,1), spot_dot{j});
end
hold
axis([1 E 0 50]);

grid on
ylabel('% of Scored Goals');
xlabel('Episodes');
legend(pt,legendN);
if record
    saveas(gcf,[folder 'fig.fig']); 
end

end

function [M, S, n, legendN] = load_results(results, M, S, n, legendN, leg)
    %A= (results.time>60) .* (6000./(results.time));
    N=size(results.mean_goals,2);
    M(:,n,1) = results.mean_goals';
    S(:,n,1) = results.std_goals'/sqrt(N); % (1/sqrt(25 runs)) for standard error
    legendN{n} = leg;
    n = n+1;
end




