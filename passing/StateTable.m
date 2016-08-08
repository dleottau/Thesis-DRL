function [ cores, nstates] = StateTable( feature_min, feature_step, feature_max )
% BuildStateList builds a state list from a state matrix

ro = feature_min(1) : feature_step(1) : feature_max(1);
% gama = feature_min(2) : feature_step(2) : feature_max(2);
% fi   = feature_min(3) : feature_step(3) : feature_max(3);

ro_std = ro*0 + feature_step(1)*0.5;
% gama_std = gama*0 + feature_step(2)*1;
% fi_std   = fi*0 + feature_step(3)*1;

% ro = [25 100 350 feature_max(1)];
gama = [feature_min(2) -15 0 15 feature_max(2)];
fi   = [feature_min(3) -15 0 15 feature_max(3)];

% ro_std = [13 25 125 250];
gama_std = [30 15 8 15 30];
fi_std   = [30 15 8 15 30];

vw     = feature_min(4) : feature_step(4) : feature_max(4);
vw_std = vw*0 + feature_step(4)*0.5;

cores.mean.ro   = ro;
cores.mean.gama = gama;
cores.mean.fi   = fi;
cores.mean.vw   = vw;
cores.std.ro    = ro_std;
cores.std.gama  = gama_std;
cores.std.fi    = fi_std;
cores.std.vw    = vw_std;

nstates = length(ro)*length(gama)*length(fi)*length(vw);