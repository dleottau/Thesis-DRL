function TD = getTemporalDifference( FV, a, r, FVp, ap, Q, param)
                                      
Qa = getQvalue(Q(:,a), FV);
Qap = getQvalue(Q(:,ap), FVp);
TD = r + param.gamma*Qap - Qa;