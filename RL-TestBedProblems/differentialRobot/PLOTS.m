function PLOTS()

clear all
close all
clc

record=0;

spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW=[3 2 2 2 3 2 2 2];
legendN=[];

K=12; % # points ploted for errobar
span=0.00001;
%span=0.07;

n=1;
M=[];
S=[];


folder = 'final/'; 

stringName = 'MAapproach0; jointState0; DRL1; lambda0.9; beta8; k-leninet3; alpha0.5; decay8; softmax3; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'fDRL');

stringName = 'MAapproach1; jointState0; DRL1; lambda0.9; beta8; k-leninet2; alpha0.3; decay8; softmax2; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'fDRL-CAdec');

stringName = 'MAapproach2; jointState0; DRL1; lambda0.9; beta0.9; k-leninet1; alpha0.5; decay0.9; softmax1; 25RUNS_k1_beta0.9.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'fDRL-Lenient');

stringName = 'MAapproach3; jointState0; DRL1; lambda0.9; beta7; k-leninet0; alpha0.5; decay7; softmax0; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'fDRL-CAinc');


% stringName = 'fuz-DRL1; lambda0.95; softmax1.1; decay9; alpha0.3; Nactions3; 25RUNS.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Hybrid');
% 
% stringName = 'MAapproach1; DRL1; lambda0.95; alpha0.4; softmax1.1; decay10; 25RUNS.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-CAdec');
% % 
% stringName = 'MAapproach-Inc1; DRL1; lambda0.95; beta0.7; k-leninet1; alpha0.3; decay13; softmax0.5; 29RUNS.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-CAinc');
% % 
% % 
% stringName = 'MAapproach2; DRL1; lambda0.95; softmax2; alpha0.3; decay8; beta0.7; k-leninet1; 25RUNS_k1_beta0.7.mat';
% results=importdata([folder stringName]);
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Lenient');
% 


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
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on
for j=1:size(M,2)
    pt(j)=plot(Ms(:,j,1), spot{j}, 'LineWidth',lineW(j))
    errorbar(x(:,j) ,MK(:,j,1),SK(:,j,1), spot_dot{j})
end
hold
axis([1 E 0 100])

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
    
    %N=size(results.mean_goals,2);
    
    M(:,n,1) = results.mean_goals';
    %M(:,n,2) = results.mean_faults';
    
    S(:,n,1) = results.std_goals';
    %S(:,n,2) = results.std_faults';
    
    legendN{n} = leg;
    n = n+1;
end




