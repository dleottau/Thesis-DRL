function [ cores, nstates ] = BuildStateList(cfg)
%function [ cores ] = BuildStateList
%BuildStateList builds a state list from a state matrix

% state discretization for the mountain car problem
%xdiv  = (0.55-(-1.5))   / cfg.nCores(1);   %10
%xpdiv = (0.07-(-0.07)) / cfg.nCores(2);  %5



div = (cfg.feature_max-cfg.feature_min) ./ cfg.nCores;  

nstates=1;
for i=1:length(div)
    means{i} = cfg.feature_min(i) : div(i) : cfg.feature_max(i);
    stdvs{i} = means{i}*0 + div(i)*cfg.stdDiv(i);
    nstates=nstates*length(means{i});
end


% xdiv  = (cfg.feature_max(1)-(cfg.feature_min(1))) / cfg.nCores(1);  
% ydiv  = (cfg.feature_max(2)-(cfg.feature_min(2))) / cfg.nCores(2);  
% xpdiv = (cfg.feature_max(3)-(cfg.feature_min(3))) / cfg.nCores(3);  
% ypdiv = (cfg.feature_max(4)-(cfg.feature_min(4))) / cfg.nCores(4);  


% x = cfg.feature_min(1) : xdiv : cfg.feature_max(1);
% y = cfg.feature_min(2) : ydiv : cfg.feature_max(2);
% xp= cfg.feature_min(3) : xpdiv : cfg.feature_max(3);
% xp= cfg.feature_min(4) : ypdiv : cfg.feature_max(4);

%x_std = x*0 + xdiv*cfg.stdDiv(1);
%xp_std = xp*0 + xpdiv*cfg.stdDiv(2);


cores.mean.x = means{1};
cores.mean.y = means{2};
cores.mean.xp = means{3};
cores.mean.yp = means{4};

cores.std.x = stdvs{1};
cores.std.y = stdvs{2};
cores.std.xp = stdvs{3};
cores.std.yp = stdvs{4};

% cores.mean.x = x;
% cores.mean.xp = xp;
% cores.std.x = x_std;
% cores.std.xp = xp_std;

%nstates=length(means{1})*length(means{3});

