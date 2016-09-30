function PLOTS()

%clear all
close all
clc

%record =  true;

spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
lineW=[2 1 1 1 2 1 1 1];


legendN=[];
K=10; % # points ploted for errobar
span=0.07;

n=1;
M=[];
S=[];

% ----------
% spot={':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g' ':r' '-g' '-.c' '--k'  ':b' '-m' '-.r' '--g'};
% spot_dot={'.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g' '.r' '.g' '.c' '.k' '.b' '.m' '.r' '.g'};
% lineW=[2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1];
% 
% folder = 'opti/CoSh/test03/'; %triang1Sat03  test303
% files = dir(fullfile([folder '*.mat']));
% 
% for i=1:size(files,1)
%     results=importdata([folder files(i).name]);
%     [M,S,n,legendN] = load_results(results,M,S,n,legendN,files(i).name);
% end
% ----------

load opti/NeASh/triang1Sat03/DRL_8Runs_Noise0.1_MA0_alpha0.3_lambda0.8_softmax4_decay9_NeASh9.mat;
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL+NeASh-triangSat-Best');

load opti/NeASh/triang1Sat03/DRL_8Runs_Noise0.1_MA0_alpha0.3_lambda0.8_softmax4_decay11_NeASh9.mat;
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL+NeASh-triangSat-Fast');

load 'opti/NeASh/test303/ScaleNeash19; NeASh1; Transfer1; k-lenient1.5; MAapproach0; beta0.9; lambda0.8; decay13; softmax6; alpha0.3.mat'
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL+NeASh-Gauss-Best&Fast');

load 'opti/CoSh/test03/ScaleNeash2; NeASh0; Transfer1; k-lenient1.5; MAapproach0; beta0.9; lambda0.8; decay6; softmax2; alpha0.3.mat'
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL+CoSh-Best');

load 'opti/CoSh/test03/ScaleNeash2; NeASh0; Transfer1; k-lenient1.5; MAapproach0; beta0.9; lambda0.8; decay11; softmax2; alpha0.3.mat'
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL+CoSh-Fast');

% load opti/CoSh/DRL_8Runs_Noise0.1_MA0_alpha0.3_lambda0.8_softmax11_decay11_CoSh.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL+CoSh');

%---------------------
%load finalTests/DRL_25Runs_Noise0.1_MA0_alpha0.5_lambda0.9_softmax70_decay6.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL');
% %  
% load 'finalTests/DRL_25Runs_Noise0.1_MA1_alpha0.2_lambda0.8_softmax11_decay7.mat'
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-CAdec');
% %  
%load finalTests/DRL_25Runs_Noise0.1_MA2_alpha0.1_lambda0.9_k1.5_beta0.9_softmax70_decay6.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-Lenient');
% %  
%load RC-2015/results/resultsFull_NASh-v2-20runs-Noise01-exp8.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL+Transfer');

%load 'finalTests/DRL_6Runs_Noise0.1_MAinc1_alpha0.3_lambda0.9_softmax71_decay11.mat'
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-CAinc');

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
subplot(3,1,1);    
set(gca,'fontsize',14)
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on
for j=1:size(M,2)
    pt(j)=plot(Ms(:,j,1), spot{j}, 'LineWidth',lineW(j));
    errorbar(x(:,j) ,MK(:,j,1),SK(:,j,1), spot_dot{j});
end
axis([1 E 0 100])
%axis([1 160 0 100])
%legend(pt,legendN)
%title('% Vmax') ; 
grid on
ylabel('% of max. forward speed');
hold

%figure
subplot(3,1,2); 
set(gca,'fontsize',14)
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on
for j=1:size(M,2)     
    pf(j)=plot(Ms(:,j,2), spot{j}, 'LineWidth',lineW(j));
    errorbar(x(:,j), MK(:,j,2),SK(:,j,2), spot_dot{j});
end
axis([1 E 0 100])
grid on
ylabel('% of time in fault-state');
%legend(pt,legendN);
hold

%figure
%Solo para el fitness global
subplot(3,1,3); 
set(gca,'fontsize',14)
hold on
for j=1:size(M,2)     
     pf2(j)=plot(.5*(100-Ms(:,j,1)+Ms(:,j,2)), spot{j}, 'LineWidth',lineW(j));
     errorbar(x(:,j), .5*(100-MK(:,j,1)+MK(:,j,2)), .5*(SK(:,j,1)+SK(:,j,2)), spot_dot{j});
end
axis([1 E 0 100])
grid on
xlabel('Episodes');
ylabel('Global Fitness');
legend(pt,legendN);
hold

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
    N=size(results.faults,2);
    
    M(:,n,1) = results.mean_Vavg';
    M(:,n,2) = results.mean_faults';
    %M(:,n,3) = results.mean_rewX';
    %M(:,n,4) = results.mean_rewY';
    %M(:,n,5) = results.mean_rewRot';
    
    S(:,n,1) = results.std_Vavg'/sqrt(N);  % Computing standard error
    S(:,n,2) = results.std_faults'/sqrt(N); % Computing standard error
    %S(:,n,3) = results.std_rewX';
    %S(:,n,4) = results.std_rewY';
    %S(:,n,5) = results.std_rewRot';

    legendN{n} = leg;
    n = n+1;
    
    %results.performance(1,3)  %To see fitness
    %results.performance(1,6)  %To see time to threshold
end

% load boltzmann/Vx-5runs-Noise02-50exp10-NoSync-boltzmann20.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp20-50expl10');
% 
% 
% load boltzmann/Vx-5runs-Noise02-50exp5-NoSync-boltzmann20.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp20-50expl5');
% 
% load boltzmann/Vx-20runs-Noise02-50exp5-NoSync-boltzmann5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp5-50expl5');
% 
% load boltzmann/Vx-20runs-Noise02-50exp10-NoSync-boltzmann5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp5-50expl10');
% 
% load boltzmann/Vx-20runs-Noise02-50exp10-NoSync-egready.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'egreedy-50expl10');
% 
% load boltzmann/Vx-20runs-Noise02-50exp30-NoSync-egready.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'egreedy-50expl30');


% load boltzmann/Vx-3runs-Noise02-50exp5-NoSync-boltzmann5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp5-50expl5');
% 
% load boltzmann/Vx-3runs-Noise02-50exp10-NoSync-boltzmann5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp5-50expl10');
% 
% load boltzmann/Vx-3runs-Noise02-50exp5-NoSync-boltzmann10.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp10-50expl5');
% 
% load boltzmann/Vx-3runs-Noise02-50exp10-NoSync-boltzmann10.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp10-50expl10');


% load boltzmann/Vx-3runs-Noise01-50exp30-NoSync-boltzmann5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp5-50expl30');
% 
% load boltzmann/Vx-3runs-Noise01-50exp50-NoSync-boltzmann5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp5-50expl50');
% 
% load boltzmann/Vx-3runs-Noise01-50exp10-NoSync-boltzmann10.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp10-50expl10');
% 
% load boltzmann/Vx-3runs-Noise01-50exp30-NoSync-boltzmann10.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp10-50expl30');
% 
% load boltzmann/Vx-3runs-Noise01-50exp50-NoSync-boltzmann10.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'temp10-50expl50');


% load NASh/NASh-10runs-Noise01-1200exp7-NoSync.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-NoSync');
% 
% load NASh/NASh-10runs-Noise01-1200exp7-NAShExplSync.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-nashExplSync');
% 
% load NASh/NASh-10runs-Noise01-1200exp7-TLSync.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-TLSync');
% 
% load NASh/NASh-10runs-Noise01-1200exp7-FullSync.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NASh-FullSync');

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

%load RC-2015/results/resultsFull_NASh.mat
%[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL-NASh');
 
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

