function [Q, e_trace] = UpdateSARSAca(Q, e_trace, TD, FV, a, RLparam, ca)


FVT      = zeros(size(Q,1),size(Q,2));
FVT(:,a) = FV;

e_trace = e_trace* RLparam.gamma * RLparam.lambda + FVT;
Q       =  Q + ca*RLparam.alpha * ( e_trace*TD);
        