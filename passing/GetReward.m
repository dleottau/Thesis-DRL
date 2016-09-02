function [r,f] = GetReward(X, Pr, Pb, Pt,checkGoal,Pbi,ballState,conf)
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if terminal state, otherwise f is false

feature_max   = conf.feature_max;
maxDistance_x = conf.maxDistance_x;
maxDistance_y = conf.maxDistance_y;
f_gmm         = conf.f_gmm;

ro   = X(1);
gama = X(2);
fi   = X(3);
f    = false;

th_max = feature_max(1:3);

% Ball-Target Distance.-
d_BT2 = 1 - f_gmm(Pbi(1),Pbi(2)) / f_gmm(0,0);

if ballState == 0
    r(1) = - 1 * ( sum([ro abs(gama) abs(fi)] .* 1/th_max) + d_BT2 );
else
    r(1) = - 1 * d_BT2;
end

if checkGoal
    f    = true;
    r(1) = conf.Rgain * f_gmm(Pbi(1),Pbi(2));
end

r(2) = r(1);
r(3) = r(1);

if( Pr(1) > abs(maxDistance_x) || Pr(2) > abs(maxDistance_y/2) ||  Pb(1) > abs(maxDistance_x/2) || Pb(2) > abs(maxDistance_y/2) || Pr(1) < Pt(1) || ballState == 3)
    f = true;
end