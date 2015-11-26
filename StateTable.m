function [ States,cores,div_disc ] = StateTable(feature_min, feature_step, feature_max )
%BuildStateList builds a state list from a state matrix

ro = feature_min(1) : feature_step(1) : feature_max(1);
gama = feature_min(2) : feature_step(2) : feature_max(2);
fi = feature_min(3) : feature_step(3) : feature_max(3);

 
N=size(ro,2);
M=size(gama,2);
O=size(fi,2);


States=[];
index=1;

for i=1:N   
for j=1:M
for k=1:O

    States(index,1)=ro(i);
    States(index,2)=gama(j);
    States(index,3)=fi(k);
    index=index+1;
end
end
end

cores.ro=ro;
cores.gama=gama;
cores.fi=fi;

div_disc_=[size(cores.ro,2) size(cores.gama,2) size(cores.fi,2)];
%div_disc_=size(cores.ro,2);

for i=1:size(div_disc_,2)-1
    div_disc(i)=prod(div_disc_(i+1:size(div_disc_,2)));
end
div_disc(size(div_disc_,2))=1;