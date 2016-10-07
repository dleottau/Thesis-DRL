function [ cores, nstates, div_disc] = StateTable( feature_min, feature_step, feature_max )
% BuildStateList builds a state list from a state matrix

ro = feature_min(1) : feature_step(1) : feature_max(1);
<<<<<<< HEAD

ro_std = ro*0 + feature_step(1)*0.5;

gama = [feature_min(2) -15 0 15 feature_max(2)];
fi   = [feature_min(3) -15 0 15 feature_max(3)];

gama_std = [30 15 8 15 30];
fi_std   = [30 15 8 15 30];

dBT     = feature_min(4) : feature_step(4) : feature_max(4);
dBT_std = dBT*0 + feature_step(4)*0.5;
=======
ro_std = ro*0 + feature_step(1)*0.5;

gama = feature_min(2): feature_step(2) : feature_max(2);
gama_std = gama*0 + feature_step(2)*0.5;

%gama = [feature_min(2) -35 -15 0 15 35 feature_max(2)];
%gama_std = [45 30 15 8 15 30 45];

fi   = feature_min(3): feature_step(3) :feature_max(3);
fi_std   = fi*0 + feature_step(3)*0.5;

%fi   = [feature_min(3) -50 -15 0 15 50 feature_max(3)];
%fi_std   = [50 30 15 8 15 30 50];

dBT     = feature_min(4) : feature_step(4) : feature_max(4);
dBT_std = dBT*0 + feature_step(4)*0.5;

>>>>>>> cf75efb6535d7fe341eacdca1e4878b07458e3cb

cores.mean.ro   = ro;
cores.mean.gama = gama;
cores.mean.fi   = fi;
cores.mean.dBT  = dBT;
cores.std.dBT   = dBT_std;
cores.std.ro    = ro_std;
cores.std.gama  = gama_std;
cores.std.fi    = fi_std;

nstates = length(ro)*length(gama)*length(fi)*length(dBT);

% ----------------------------------------------------------------- %
div_disc_ = [size(cores.mean.ro,2) size(cores.mean.gama,2) size(cores.mean.fi,2) size(cores.mean.dBT,2)];

for i = 1:size(div_disc_,2)-1
    div_disc(i) = prod(div_disc_(i+1:size(div_disc_,2)));
end
div_disc(size(div_disc_,2)) = 1;
% ----------------------------------------------------------------- %