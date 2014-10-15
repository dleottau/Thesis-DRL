function PLOTS()

K=10; % # points ploted for errobar

n=1;
R=[];
load 'results2_Learn_D-RL'
%load 'results'
[R,n] = load_results(results,R,n);
% load 'results3_Learn_D-RL'
% [R,n] = load_results(results,R,n);
% load 'results4_Learn_D-RL'
% [R,n] = load_results(results,R,n);
% load 'results5_Learn_D-RL'
% [R,n] = load_results(results,R,n);

R(:,:,1)=R(:,:,1)/1.5; %aqui se cuadra que el timepo del simulador corresponda al de matlab. Recordar que la caminata está acelerada 1.5 veces en el simulador y 1.8 veecs en el robot real con respecto al Vx requested
%R(:,:,1)=R(:,:,1); 

span=0.05;
for i=1:size(R,3)
    mR(:,i)=mean(R(:,:,i),2);
    mRs(:,i)=smooth( mR(:,i), span,'rloess');
    sR(:,i) = std(R(:,:,i),0,2);
end    

%Normalizando la recompensa entre -1 y 1;
mRx = mRs(:,3);
normLRX = mRx<0;
normHRX = mRx>0;
mRs(:,3) = mRx/abs(min(mRx)*1.5).*normLRX + mRx.*normHRX;

E=size(R,1);
L=floor(E/K);
for k=1:K-1
    x(k,1) = k*L;
    for i=1:size(R,3)
        mRK(k,i) = mRs(k*L,i);
        sRK(k,i) = sR(k*L,i);
    end
end

figure

subplot(2,1,1);    
plot(mRs(:,1),'k')
hold on
errorbar(x,mRK(:,1),sRK(:,1),'.k')
%axis([1 E 0 100])
title('Episode time (s)') ; grid on
hold

subplot(2,1,2)
plot(mRs(:,2),'k')
hold on
errorbar(x,mRK(:,2),sRK(:,2),'.k')
%axis([1 E 0 100])
title('% Faults') ; grid on
hold

figure
subplot(3,1,1); plot( mRs(:,3),'k' );
%hold on; errorbar(x,mRK(:,3),sRK(:,3),'.k'); hold
title('Mean reward_x'); grid on

subplot(3,1,2); plot( mRs(:,4),'k' ); 
%hold on; errorbar(x,mRK(:,4),sRK(:,4),'.k'); hold
title('Mean reward_y'); grid on

subplot(3,1,3); plot( mRs(:,5),'k' ); 
%hold on; errorbar(x,mRK(:,5),sRK(:,5),'.k'); hold
title('Mean reward_{rot}'); grid on

end

function [R,n] = load_results(results,R,n)
    R(:,n,1) = results.mean_eTime';
    R(:,n,2) = results.mean_faults';
    R(:,n,3) = results.mean_rewX';
    R(:,n,4) = results.mean_rewY';
    R(:,n,5) = results.mean_rewRot';
    n = n+1;
end

