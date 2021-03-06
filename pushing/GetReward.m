function [r,f] = GetReward(X, Vr_max, feature_max, Pr, Pb, Pt, goalSize,maxDistance,checkGoal,Pbi,ballState,Vr)
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if terminal state, otherwise f is false

ro = X(1);
gama  = X(2);
fi = X(3);
f=false;
f_ok=false;

Vxrmax = Vr_max(1)*0.3;
th_max=feature_max(1:3);
thres = [ro  abs(gama) abs(fi)] > th_max;
angleFactor = 1;


r(1) = - 1*( sum([ro abs(gama) abs(fi)].*1/th_max) );
r(2) = r(1);

if checkGoal
     f=true;
     r(1) = 10*(1.1 - abs(Pbi(1)-Pt(1))/(goalSize/2));
     r(2) = r(1);
end



%if(ballState==3 || (ballState==0 && (Pr(1)>maxDistance || Pr(1)<0 || Pr(2)>maxDistance || Pr(2)<0 ||  Pb(1)>maxDistance || Pb(1)<0 || Pb(2)>maxDistance || Pb(2)<0 ||  abs(gama) > 90   ||  abs(fi) > 150)))
if(Pr(1)>maxDistance || Pr(1)<0 || Pr(2)>maxDistance || Pr(2)<0 ||  Pb(1)>maxDistance || Pb(1)<0 || Pb(2)>maxDistance || Pb(2)<0 )
    f=true;
end




%r(2) = -0.1;
%if abs(gama)<5 && abs(fi)<5
%    r(2) = 1;
%end


%if sum(thres)~=0 || Vr(1) < Vxrmax
%     r(1) = - ( (1-Vr(1)/Vxrmax) + sum(thres .* [ro abs(gama) abs(fi)] .*1/th_max) );
% else
%     r(1) = Vr(1)/Vxrmax;
% end



%r(1) = -0.1;%*(sum([1*ro  1.0*abs(gama) 1*abs(fi)]./feature_max));
%r(2) = -0.1*(sum([0*ro  0.3*abs(gama) 1*abs(fi)]./feature_max));


