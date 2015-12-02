function PLOTS()

clear all
close all
clc

spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW=[3 2 2 2 3 2 2 2];
legendN=[];

K=10; % # points ploted for errobar
span=0.00001;
%span=0.07;

n=1;
M=[];
S=[];


folder = 'final/'; 

stringName = 'DRL0; lambda0.9; alpha0.5; softmax2; decay7; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'CRL');

stringName = 'DRL1; lambda0.9; alpha0.3; softmax1.1; decay10; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL');

stringName = 'fuz-DRL1; lambda0.95; softmax1.1; decay9; alpha0.3; Nactions3; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-FQL');

stringName = 'MAapproach1; DRL1; lambda0.95; alpha0.4; softmax1.1; decay10; 25RUNS.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-CALR');

stringName = 'MAapproach2; DRL1; lambda0.95; softmax2; alpha0.3; decay8; beta0.7; k-leninet1; 25RUNS_k1_beta0.7.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-LRL');







%load MAS-coop/DRL-3runs-Noise005-2000exp8-NoSync-egreedy.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'e-greedy');








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
saveas(gcf,[folder 'CRLvsDRL.fig'])
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




