function [RL, TD]=UpdateQ(conf, RL, FV,a, r, FVp, ap)

if conf.MAapproach==4
    TD(1) = getTDQ(RL.Q,FV,a(1),r(1),FVp,ap(1),RL.param);
    TD(2) = getTDQ(RL.Qy,FV,a(2),r(2),FVp,ap(2),RL.param);
    TD(3) = getTDQ(RL.Q_rot,FV,a(3),r(3),FVp,ap(3),RL.param);

%     if all(TD>=0), RL.param.ca = 0*RL.param.ca+max(RL.param.ca); 
%     elseif all(TD<0), RL.param.ca = 0*RL.param.ca+(1-max(RL.param.ca)); 
%     else
%         RL.param.ca = 0*RL.param.ca+max(RL.param.ca); 
%     end

    if all(TD>=0), RL.param.ca=RL.param.ca;
    elseif all(TD<0), RL.param.ca = 1-RL.param.ca; 
    else
        RL.param.ca = 1-RL.param.ca; 
    end
    

    
    [RL.Q, RL.trace] = UpdateSARSAca(RL.Q, RL.trace, TD(1), FV, a(1), RL.param, RL.param.ca(1)); 
    [RL.Qy, RL.trace_y] = UpdateSARSAca(RL.Qy, RL.trace_y, TD(2), FV, a(2), RL.param, RL.param.ca(2));
    [RL.Q_rot, RL.trace_rot] = UpdateSARSAca(RL.Q_rot, RL.trace_rot, TD(3), FV, a(3), RL.param, RL.param.ca(3));
        

else
    [RL.Q_rot, RL.trace_rot, TD(3)] = UpdateSARSA(FV, a(3), r(3), FVp, ap(3), RL.Q_rot, RL.trace_rot, RL.param, RL.T_rot, conf.MAapproach, RL.param.ca(3));
    % -------------------------------------------------------------
    [RL.Qy, RL.trace_y, TD(2)] = UpdateSARSA(FV, a(2), r(2), FVp, ap(2), RL.Qy, RL.trace_y, RL.param, RL.T_y, conf.MAapproach, RL.param.ca(2));
    % -------------------------------------------------------------
    if conf.fuzzQ                                                                                                           % Fuzzy Q learning
        [ RL.Q, RL.trace, RL.U, RL.Qv] = UpdateQfuzzy(FV, r(1), RL.Q, RL.trace, RL.param, RL.Qv);
    else                                                                                                                    % SARSA
        [RL.Q, RL.trace, TD(1)] = UpdateSARSA(FV, a(1), r(1), FVp, ap(1), RL.Q, RL.trace, RL.param, RL.T, conf.MAapproach, RL.param.ca(1));
    end

end        
