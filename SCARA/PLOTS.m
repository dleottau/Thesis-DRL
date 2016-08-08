function PLOTS()

clear all
close all
clc

spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW=[3 2 2 2 3 2 2 2];
legendN=[];
STEPS=400;

K=7; % # points ploted for errobar
%span=0.00001; 0.2
span=0.11;

n=1;
M=[];
S=[];


folder = 'finalTests/'; 

stringName = 'MAapproach0; gamma1; lenientBeta0.9; lenientGain1.5; softmax10; epsilon0.01; alpha0.3.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN, STEPS,'DRL');

stringName = 'e-greedy-MAapproach1; gamma1; lenientBeta0.8; epsilon0.01; alpha0.3; lenientGain0.6.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN, STEPS,'DRL-CAdec');

stringName = 'e-greedy-MAapproach-Inc1; gamma1; lenientBeta0.8; epsilon0.01; alpha0.3; lenientGain1.6.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN, STEPS,'DRL-CAinc');

stringName = 'e-greedy-MAapproach2; gamma1; epsilon0.01; alpha0.3; lenientBeta0.8; lenientGain2.1.mat';
results=importdata([folder stringName]);
[M,S,n,legendN] = load_results(results,M,S,n,legendN, STEPS,'DRL-Lenient');



S=S/5; % Standar error

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
%L=floor(E/K);
L=ceil(E/K);
MK=zeros(K-1,size(M,2),size(M,3));
SK=MK;
%for k=floor(K/2):K-1
for k=1:K-1
    for i=1:size(M,3)
        for j=1:size(M,2)
            s = round((k)*L + (j-1)*L/(2*size(M,2)));
            x(k,j) = s;
            MK(k,j,i) = Ms(s,j,i);
            SK(k,j,i) = Ss(s,j,i);
        end
    end
end




figure
set(gca,'fontsize',16)
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on
for j=1:size(M,2)
    pt(j)=plot(Ms(:,j,1), spot{j}, 'LineWidth',lineW(j))
    errorbar(x(:,j) ,MK(:,j,1),SK(:,j,1), spot_dot{j})
end
hold 
axis([1 E 0 STEPS])

grid on
ylabel('Steps');
xlabel('Episodes');
legend(pt,legendN);
%saveas(gcf,[folder 'CRLvsDRL.fig'])
end

function [M, S, n, legendN] = load_results(results, M, S, n, legendN, STEPS, leg)
    
    M(:,n,1) = STEPS/100*results.cumSteps_mean';
    S(:,n,1) = STEPS/100*results.cumSteps_std';
        
    legendN{n} = leg;
    n = n+1;
end




