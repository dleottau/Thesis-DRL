function [r,f,flag_shoot] = GetReward(X, Pr, Pb, Pt, checkGoal, Pbi, ballState,conf)
% Dribbling1d returns the reward at the current state
% x: a vector of Pr Pb and Pt
% r: the returned reward.
% f: true if terminal state, otherwise f is false

feature_max   = conf.feature_max;
maxDistance_x = conf.maxDistance_x;
maxDistance_y = conf.maxDistance_y;

% --------------------------------------------------
ro   =  X(1);
gama =  X(2);
fi   =  X(3);
f    = false;
% --------------------------------------------------
P_ini = conf.Pb(1) - 2 * conf.Pb(1)/3;
if conf.Pt(1) < Pbi(1) && Pbi(1) < P_ini
    
    % Recta bola - poste izquierdo.-
    m_L = (conf.PgoalPostL(2) - conf.Pb(2)) / (conf.PgoalPostL(1) - conf.Pb(1));
    y_i = m_L * (Pbi(1) - conf.PgoalPostL(1)) + conf.PgoalPostL(2);
    
    if y_i < Pbi(2)
        
        % Recta bola - poste derecho.-
        m_d = (conf.PgoalPostR(2) - conf.Pb(2)) / (conf.PgoalPostR(1) - conf.Pb(1));
        y_d = m_d * (Pbi(1) - conf.PgoalPostR(1)) + conf.PgoalPostR(2);
        
        if Pbi(2) < y_d
            R_shoot = 10 * ( (1 + abs(Pbi(1) - P_ini) / (abs(conf.Pt(1) - P_ini))) ^ 2 - 1 ) + 4 * exp(-abs(Pbi(2))/250);
            flag_shoot = 1;
        else
            R_shoot    = 0;
            flag_shoot = 0;
        end
        
    else
        R_shoot    = 0;
        flag_shoot = 0;
    end
    
else
    R_shoot    = 0;
    flag_shoot = 0;
end
% --------------------------------------------------

% r(1) = - 1 * ( sum([ro abs(gama) abs(fi)] .* 1/feature_max(1:3)));
r(1) = - 1 * ( sum([ro abs(gama) abs(fi)] ./feature_max(1:3))) + R_shoot;

if checkGoal
    r(1) = conf.Rgain*exp(-abs(Pbi(2))/500);
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