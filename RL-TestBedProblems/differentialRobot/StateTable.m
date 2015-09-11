function [ cores, nstates] = StateTable(feature_min, feature_step, feature_max )
%BuildStateList builds a state list from a state matrix

ro = feature_min(1) : feature_step(1) : feature_max(1);
% gama = feature_min(2) : feature_step(2) : feature_max(2);
% fi = feature_min(3) : feature_step(3) : feature_max(3);

ro_std = ro*0 + feature_step(1)*1;
% gama_std = gama*0 + feature_step(2)*1;
% fi_std = fi*0 + feature_step(3)*1;

%ro = [25 100 350 feature_max(1)];
gama = [feature_min(2) -30 0 30 feature_max(2)];
fi = [feature_min(3) -30 0 30 feature_max(3)];
% % 
%ro_std = [13 25 125 250];
gama_std = [30 15 8 15 30];
fi_std = [30 15 8 15 30];

cores.mean.ro = ro;
cores.mean.gama = gama;
cores.mean.fi = fi;
cores.std.ro = ro_std;
cores.std.gama = gama_std;
cores.std.fi = fi_std;

R=length(ro);
G=length(gama);
F=length(fi);

nstates = R*G*F;

% 
% States=zeros(nstates,3);
% index=1;
% 
% for i=1:R   
% for j=1:G
% for k=1:F
% 
%     States(index,1)=ro(i);
%     States(index,2)=gama(j);
%     States(index,3)=fi(k);
%     index=index+1;
% end
% end
% end
% 
% 
% div_disc_=[R, G, F];
%  for i=1:size(div_disc_,2)-1
%      div_disc(i)=prod(div_disc_(i+1:size(div_disc_,2)));
%  end
% div_disc(size(div_disc_,2))=1;