function [r,f] = GetReward(X, feature_max, Pr, Pb, Pt,maxDistance,checkGoal,Pbi,ballState,area_fin,time,f_gmm,pbx,pby,conf)
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if terminal state, otherwise f is false

ro   = X(1);
gama = X(2);
fi   = X(3);
f    = false;

th_max = feature_max(1:3);

% Distancia Bola-Target.-
d_BT = (sqrt((Pbi(1) - Pt(1))^2 + (Pbi(2) - Pt(2))^2)) / sqrt(pbx^2 + pby^2);

r(1) = - 1*( sum([ro abs(gama) abs(fi)].*1/th_max) + d_BT );
r(2) = r(1);

% Se penaliza cuando la bola queda lejos de la elipse.-
% if checkGoal ~= 1 && (ballState == 3 || time > 60)
%     r(1) = r(1) - 2 * (sqrt((Pbi(1) - Pt(1))^2 + (Pbi(2) - Pt(2))^2)) / sqrt(pbx^2 + pby^2);
%     r(2) = r(1);
% end

if checkGoal
    f    = true;
    switch area_fin
        %         case 1
        %             r(1) = 600 * 1/(1 + (sqrt((Pbi(1) - Pt(1))^2 + (Pbi(2) - Pt(2))^2)) );
        %             r(2) = r(1);
        %         case 2
        %             r(1) = 500 * 1/(1 + (sqrt((Pbi(1) - Pt(1))^2 + (Pbi(2) - Pt(2))^2)) );
        %             r(2) = r(1);
        case 3
            % r(1) = 1000 * 1/(1 + (sqrt((Pbi(1) - Pt(1))^2 + (Pbi(2) - Pt(2))^2)) );
            % r(1) = 2000 * 1/(1 + (Pbi(1) - Pt(1))^2 + (Pbi(2) - Pt(2))^2);
            % keyboard
            r(1) = conf.Rgain * f_gmm(Pbi(1),Pbi(2));
            r(2) = r(1);
    end
end

% if(ballState==3 || (ballState==0 && (Pr(1)>maxDistance || Pr(1)<0 || Pr(2)>maxDistance || Pr(2)<0 ||  Pb(1)>maxDistance || Pb(1)<0 || Pb(2)>maxDistance || Pb(2)<0 ||  abs(gama) > 90   ||  abs(fi) > 150)))
% if( Pr(1) > maxDistance || Pr(1) < Pt(2) || Pr(2) > maxDistance || Pr(2) < Pt(2) ||  Pb(1) > maxDistance || Pb(1) < Pt(2) || Pb(2) > maxDistance || Pb(2) < Pt(2) || ballState == 3)
if( Pr(1) > maxDistance || Pr(1) < 0 || Pr(2) > maxDistance || Pr(2) < -1000 ||  Pb(1) > maxDistance || Pb(1) < 0 || Pb(2) > maxDistance || Pb(2) < -1000 || ballState == 3)
    f = true;
end