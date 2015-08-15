function [ cores, nstates ] = BuildStateList(cfg)
%function [ cores ] = BuildStateList
%BuildStateList builds a state list from a state matrix

% state discretization for the mountain car problem
%xdiv  = (0.55-(-1.5))   / cfg.nCores(1);   %10
%xpdiv = (0.07-(-0.07)) / cfg.nCores(2);  %5

xdiv  = (cfg.feature_max(1)-(cfg.feature_min(1))) / cfg.nCores(1);  %10
xpdiv = (cfg.feature_max(2)-(cfg.feature_min(2))) / cfg.nCores(2);  %5

%x = -1.5:xdiv:0.5;
%xp= -0.07:xpdiv:0.07;

x = cfg.feature_min(1) : xdiv : cfg.feature_max(1);
xp= cfg.feature_min(2) : xpdiv : cfg.feature_max(2);

x_std = x*0 + xdiv*cfg.stdDiv(1);
xp_std = xp*0 + xpdiv*cfg.stdDiv(2);


cores.mean.x = x;
cores.mean.xp = xp;
cores.std.x = x_std;
cores.std.xp = xp_std;

N=size(x,2);
M=size(xp,2);
nstates=N*M;


% states=[];
% index=1;
% for i=1:N    
%     for j=1:M
%         states(index,1)=x(i);
%         states(index,2)=xp(j);
%         dev(index,1)=xdiv;
%         dev(index,2)=xpdiv;
%         index=index+1;
%     end
% end
