function [ States,cores,div_disc ] = StateTable(state_steps)
%BuildStateList builds a state list from a state matrix

ro = 0 : state_steps(1) : 600;
gama = -30 : state_steps(2) : 30;
fi = -30 : state_steps(3) : 30;

 
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
for i=1:size(div_disc_,2)-1
    div_disc(i)=prod(div_disc_(i+1:size(div_disc_,2)));
end
div_disc(size(div_disc_,2))=1;