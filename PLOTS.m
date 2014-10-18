function PLOTS()

%clear all
close all
clc

spot={':r' '-g' '-.b' '--c' ':m' '-y' '--k'};
spot_dot={'.r' '.g' '.b' '.c' '.m' '.y' '.k'};
legendN=[];

K=10; % # points ploted for errobar

n=1;
M=[];
S=[];

%load 'results'


% load resultsFull-DRL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL Qi=-5');
% load resultsFull-DRL-Qi0.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL Qi=0');
% load resultsFull-DRL-Qi5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL Qi=5');


% load resultsFull_Learn_CoSh-TD-RL-Qi-20.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Qi=-20');
% load resultsFull_Learn_CoSh-TD-RL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Qi=-5');
% load resultsFull_Learn_CoSh-TD-RL-Qi0.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Qi=0');
% load resultsFull_Learn_CoSh-TD-RL-Qi5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Qi=5');

% load resultsFull_Learn_NASh-TD-RL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NaSh Qi=-5');
% load resultsFull_Learn_NASh-TD-RL-Qi0.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NaSh Qi=0');
% load resultsFull_Learn_NASh-TD-RL-Qi5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NaSh Qi=5');
% load resultsFull_Learn_NASh-TD-RL-Qi20.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NaSh Qi=20');

% load resultsFull_Learn_CoSh-TD-RL-Qi-5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Qi=-5');
% load resultsFull_Learn_NASh-TD-RL-Qi5.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'NaSh Qi=5');
% load resultsCoSH-5FastCtrl.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'FastSrc CoSh Qi=-5');
% load resultsNash5FastCtrl.mat
% [M,S,n,legendN] = load_results(results,M,S,n,legendN,'FastSrc NaSh Qi=5');

load resultsFull-DRL-Qi0.mat
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'DRL Qi=0');
load resultsFull_Learn_CoSh-TD-RL-Qi-5.mat
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'CoSh Qi=-5');
load resultsFull_Learn_NASh-TD-RL-Qi5.mat
[M,S,n,legendN] = load_results(results,M,S,n,legendN,'NaSh Qi=5');




Ms=M;%Smoothed means
span=0.05;
for i=1:size(M,3)
    for j=1:size(M,2)
        Ms(:,j,i)=smooth( M(:,j,i), span,'rloess');
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
            SK(k,j,i) = S(s,j,i);
        end
    end
end


lineW=2;

figure

subplot(2,1,1);    
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on
for j=1:size(M,2)
    pt(j)=plot(Ms(:,j,1), spot{j}, 'LineWidth',lineW)
    errorbar(x(:,j) ,MK(:,j,1),SK(:,j,1), spot_dot{j})
end
hold
%axis([1 E 0 100])
legend(pt,legendN)
title('Episode time (s)') ; grid on


subplot(2,1,2)
plot(x(:,1),zeros(length(x(:,1))), '.w')
hold on
for j=1:size(M,2)     
    pf(j)=plot(Ms(:,j,2), spot{j}, 'LineWidth',lineW)
    errorbar(x(:,j), MK(:,j,2),SK(:,j,2), spot_dot{j})
end
hold
%axis([1 E 0 100])
title('% Faults'); grid on
legend(pf,legendN);



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
    M(:,n,1) = results.mean_eTime';
    M(:,n,2) = results.mean_faults';
    %M(:,n,3) = results.mean_rewX';
    %M(:,n,4) = results.mean_rewY';
    %M(:,n,5) = results.mean_rewRot';
    
    S(:,n,1) = results.std_eTime';
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

