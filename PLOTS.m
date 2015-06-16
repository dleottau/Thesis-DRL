function PLOTS()

%clear all
close all
clc

spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW=[3 2 2 2 3 2 2 2];
legendN=[];

K=10; % # points ploted for errobar
span=0.07;

n=1;
M=[];
S=[];


load NASh/NASh-10runs-Noise01-1200exp7-NoSync.mat
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-NoSync');

load NASh/NASh-10runs-Noise01-1200exp7-NAShExplSync.mat
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-nashExplSync');

load NASh/NASh-10runs-Noise01-1200exp7-TLSync.mat
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-TLSync');

load NASh/NASh-10runs-Noise01-1200exp7-FullSync.mat
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-FullSync');

%load NASh/NASh-10runs-Noise01-1200exp6-NAShTLSync.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-nashTLSync');



%load NASh/NASh-3runs-Noise01-1000exp6-NashSync.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-nashSync');

%load NASh/NASh-3runs-Noise01-1000exp6-explSync.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-explSync');

% 
% load NASh/NASh-3runs-Noise01-1000exp6-TLSync.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-TLSync');
% 
% load NASh/NASh-3runs-Noise01-1000exp6-NashTLSync.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-nashTLSync');

%load NASh/NASh-3runs-Noise01-1000exp6-explTLSync.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-explTLSync');

% load NASh/NASh-3runs-Noise01-1000exp6-FullSync.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-FullSync');



%=========

%load RC-2015/results/resultsFull_DRL-v2-20runs-Noise07-exp7.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL');

%load RC-2015/resultsFull_DRL-NASh-v5-10runs-Noise012-exp8-phoK3.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-NASh');

%load RC-2015/resultsFull_RL-FLC-v2-20runs-Noise02-exp20.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'RL-FLC');

%load RC-2015/results/resultsFull_NASh-v2-20runs-Noise01-exp8.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-NASh');

%load RC-2015/results/resultsFull_DRLpre.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRLpre');

load RC-2015/results/resultsFull_NASh.mat
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-NASh');
 
%load RC-2015/results/resultsFull_eRL-FLC.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'eRL-FLC');
% 
%load RC-2015/results/resultsFull_RL-FLC.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'RL-FLC');



% load resultsFull-DRL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DL Pessimistic');
% load resultsFull-DRL-Qi0.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DL Zeros');
% load resultsFull-DRL-Qi5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DL Optimistic');


% load resultsFull_Learn_CoSh-TD-RL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Pessimistic');
% load resultsFull_Learn_CoSh-TD-RL-Qi0.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Zeros');
% load resultsFull_Learn_CoSh-TD-RL-Qi5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Optimistic');
% 
% load resultsFull_Learn_NASh-TD-RL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh Pessimistic');
% load resultsFull_Learn_NASh-TD-RL-Qi0.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh Zeros');
% load resultsFull_Learn_NASh-TD-RL-Qi5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh Optimistic');

% load resultsFull_Learn_CoSh-TD-RL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Pessimistic');
% load resultsFull_Learn_NASh-TD-RL-Qi5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NaSh Optimistic');
% load resultsCoSh-5FastCtrl.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'FastSrc CoSh Pessimistic');
% load resultsNaSh5FastCtrl.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'FastSrc NASh Optimistic');
% load resultsCoSh-5SlowCtrl.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'SlowSrc CoSh Pessimistic');
% load resultsNaSh5SlowCtrl.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'SlowSrc NASh Optimistic');

% load resultsFull-DRL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL Pessimistic');
% load resultsFull_Learn_CoSh-TD-RL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Pessimistic');
% load resultsFull_Learn_NASh-TD-RL-Qi5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NaSh Optimistic');
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

subplot(3,1,1);    
%subplot(2,1,1); 
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on
for j=1:size(M,2)
    pt(j)=plot(Ms(:,j,1), spot{j}, 'LineWidth',lineW(j))
    errorbar(x(:,j) ,MK(:,j,1),SK(:,j,1), spot_dot{j})
end
hold
axis([1 E 0 100])
%axis([1 160 0 100])
%legend(pt,legendN)
%title('% Vmax') ; 
grid on
ylabel('% of max. forward speed');

subplot(3,1,2); 
%subplot(2,1,2)
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on
for j=1:size(M,2)     
    pf(j)=plot(Ms(:,j,2), spot{j}, 'LineWidth',lineW(j))
    errorbar(x(:,j), MK(:,j,2),SK(:,j,2), spot_dot{j})
end
hold
axis([1 E 0 100])
%axis([1 160 0 100])
%title('% Faults'); 
grid on
%xlabel('Episodes');
ylabel('% of time in fault-state');
%legend(pt,legendN);

%Solo para el fitness global
subplot(3,1,3); 
%subplot(2,1,2)
 hold on
 for j=1:size(M,2)     
     pf2(j)=plot(.5*(100-Ms(:,j,1)+Ms(:,j,2)), spot{j}, 'LineWidth',lineW(j))
 end
 hold
 axis([1 E 0 100])
 %axis([1 160 0 100])
 grid on
 xlabel('Episodes');
 ylabel('Global Fitness');
 legend(pt,legendN);
% 


% 
% figure
% subplot(3,1,1); plot( Ms(:,3),'k' );
% %hold on; errorbar(x,mRK(:,3),sRK(:,3),'.k'); hold
% title('Mean reward_x'); grid on
% 
% subplot(3,1,2); plot( Ms(:,4),'k' ); 
% %hold on; errorbar(x,mRK(:,4),sRK(:,4),'.k'); hold
% title('Mean reward_y'); grid on
% 
% subplot(3,1,3); plot( Ms(:,5),'k' ); 
% %hold on; errorbar(x,mRK(:,5),sRK(:,5),'.k'); hold
% title('Mean reward_{rot}'); grid on

end

function [M, S, n, legendN] = load_results(results, M, S, n, legendN, leg)
    
    %A= (results.time>60) .* (6000./(results.time));
    
    %M(:,n,1) = mean(A,2)';
    N=size(results.time,2);
    
    M(:,n,1) = results.mean_Vavg';
    M(:,n,2) = results.mean_faults';
    %M(:,n,3) = results.mean_rewX';
    %M(:,n,4) = results.mean_rewY';
    %M(:,n,5) = results.mean_rewRot';
    
    S(:,n,1) = results.std_Vavg';
    S(:,n,2) = results.std_faults';
    %S(:,n,3) = results.std_rewX';
    %S(:,n,4) = results.std_rewY';
    %S(:,n,5) = results.std_rewRot';
    
%     mRx = M(:,n,3);
%     normLRX = mRx<0;
%     normHRX = mRx>0;
%     M(:,n,3) = mRx/abs(min(mRx)*1.5).*normLRX + mRx.*normHRX;
%     S(:,n,3) = S(:,n,3)/abs(min(S(:,n,3))*1.5).*normLRX + S(:,n,3).*normHRX;
    
    legendN{n} = leg;
    n = n+1;
end

