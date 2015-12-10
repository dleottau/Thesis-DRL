function PLOTS()

clear all
close all
clc

spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW=[3 2 2 2 3 2 2 2];
legendN=[];

K=10; % # points ploted for errobar
span=0.1;
%span=0.07;

n=1;
M=[];
S=[];


folder = 'finalTests/'; 

stringName = 'MAapproach0; gamma1; lenientBeta0.9; lenientGain1.5; softmax10; epsilon0.01; alpha0.3.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL');

stringName = 'MAapproach1; gamma1; softmax10; lenientBeta0.8; lenientGain1.5; epsilon0.02; alpha0.1.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'CA-DRL');

%stringName = 'MAapproach2; gamma1; softmax10; lenientBeta0.8; lenientGain1.5; epsilon0.01; alpha0.3.mat';
stringName = 'MAapproach2; gamma1; softmax10; lenientBeta0.8; lenientGain1.5; epsilon0.01; alpha0.3.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'Lenient-DRL');



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
ylabel('% of max. steps (400)');
xlabel('Episodes');
legend(pt,legendN);
%saveas(gcf,[folder 'CRLvsDRL.fig'])
end

function [M, S, n, legendN] = load_results(results, M, S, n, legendN, leg)
    M(:,n,1) = results.cumSteps_mean';
    S(:,n,1) = results.cumSteps_std';
    
    legendN{n} = leg;
    n = n+1;
end




