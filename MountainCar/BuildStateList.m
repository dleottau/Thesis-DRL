function [ cores, nstates ] = BuildStateList(cfg)
%function [ cores ] = BuildStateList
%BuildStateList builds a state list from a state matrix

% state discretization for the mountain car problem
% xdiv  = (0.55-(-1.5))   / 10.0;
% xpdiv = (0.07-(-0.07)) / 5.0;
% 
% x = -1.5:xdiv:0.5;
% xp= -0.07:xpdiv:0.07;
% 
% x_std = x*0 + xdiv;
% xp_std = xp*0 + xpdiv;
% 
% cores.mean.x = x;
% cores.mean.xp = xp;
% cores.std.x = x_std;
% cores.std.xp = xp_std;
% 
% N=size(x,2);
% M=size(xp,2);
% nstates=N*M;


div = (cfg.feature_max-cfg.feature_min) ./ cfg.nCores;  

nstates=1;
for i=1:length(div)
    means{i} = cfg.feature_min(i) : div(i) : cfg.feature_max(i);
    stdvs{i} = means{i}*0 + div(i)*cfg.stdDiv(i);
    nstates=nstates*length(means{i});
end

cores.mean.x = means{1};
cores.mean.xp = means{2};

cores.std.x = stdvs{1};
cores.std.xp = stdvs{2};
