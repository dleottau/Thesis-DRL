function PLOTS()

%clear all
close all
clc

folder = 'experimentsFull/Delft/'; 
files = dir(fullfile([folder '*.mat']));

spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW=[2 1 1 1 2 1 1 1];
legendN=[];

K=12; % # points ploted for errobar
span=0.01;
%span=0.07;

n=1;
M=[];
S=[];

for i=1:size(files,1)
    results=importdata([folder files(i).name]);
    [M,S,n,legendN] = load_results(results,M,S,n,legendN,files(i).name);
end

S=S/5;
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
%for k=ceil(K/2):K-1
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
set(gca,'fontsize',14)
%subplot(3,1,1);    
%subplot(2,1,1); 
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on
for j=1:size(M,2)
    pt(j)=plot(Ms(:,j,1), spot{j}, 'LineWidth',lineW(j))
    errorbar(x(:,j) ,MK(:,j,1),SK(:,j,1), spot_dot{j})
end
hold
%axis([1 E 0 -5000])

grid on
ylabel('Averaged Cumulative Reward');
xlabel('Episodes');
legend(pt,legendN);
%saveas(gcf,[folder 'fig.fig'])
end

function [M, S, n, legendN] = load_results(results, M, S, n, legendN, leg)
    %A= (results.time>60) .* (6000./(results.time));
    N=size(results.reward,2);
    M(:,n,1) = results.mean_cumReward';
    S(:,n,1) = (results.std_cumReward')/sqrt(N);
    legendN{n} = leg;
    n = n+1;
end




