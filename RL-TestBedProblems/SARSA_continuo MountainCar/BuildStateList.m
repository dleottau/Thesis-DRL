function [ cores, nstates ] = BuildStateList(cfg)
%function [ cores ] = BuildStateList
%BuildStateList builds a state list from a state matrix

div = (cfg.feature_max-cfg.feature_min) ./ cfg.nCores;  

nstates=1;
for i=1:length(div)
    means{i} = cfg.feature_min(i) : div(i) : cfg.feature_max(i);
    stdvs{i} = means{i}*0 + div(i)*cfg.stdDiv;
    nstates=nstates*length(means{i});
end

cores.mean.x = means{1};
cores.mean.xp = means{2};
cores.mean.y = means{3};
cores.mean.yp = means{4};

cores.std.x = stdvs{1};
cores.std.xp = stdvs{2};
cores.std.y = stdvs{3};
cores.std.yp = stdvs{4};


if cfg.DRL==1
    nstates=length(means{1})*length(means{2});
end