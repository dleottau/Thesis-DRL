function TD = getTDQ(Q,FV,a,r,FVp,ap,RLparam)
    
Qa      = getQvalue(Q(:,a), FV);
Qap     = getQvalue(Q(:,ap), FVp);
TD      = r + RLparam.gamma*Qap - Qa;


end