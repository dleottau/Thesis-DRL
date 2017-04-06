function [r,f] = GetReward(X, Pr, Pb, Pt,checkGoal,Pbi,ballState,conf)
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if terminal state, otherwise f is false

feature_max   = conf.feature_max;
maxDistance_x = conf.maxDistance_x;
maxDistance_y = conf.maxDistance_y;
f_gmm         = conf.f_gmm;

ro   =  X(1);
gama =  X(2);
fi   =  X(3);
dBT =   X(4);

f    = false;

%r(1) = - 1 * ( sum([ro abs(gama) abs(fi) dBT] .* 1/feature_max));
r(1) = - 1 * ( sum([ro abs(gama) abs(fi)] .* 1/feature_max(1:3)));

if checkGoal
    r(1) = 200*exp(-abs(Pbi(2))/400);
%if ballState > 0 % || checkGoal
     %r(1) = conf.Rgain * f_gmm(Pbi(1),Pbi(2))
     %r(1) = 50*exp(-500/ro)*exp(-abs(Pbi(2))/750);
     %r(1) = 1 + exp(-dBT/300)*exp(-abs(Pbi(2))/750);
end

r(2) = r(1);
r(3) = r(1);
 
if( ballState == 3 || checkGoal || abs(gama)>120 || abs(fi)>160 || Pr(1) > abs(maxDistance_x/2) || Pr(2) > abs(maxDistance_y/2) ||  Pb(1) > abs(maxDistance_x/2) || Pb(2) > abs(maxDistance_y/2) || Pr(1) < Pt(1))
    f = true;
end