function [ s ] = DiscretizeState( x, statelist )
%DiscretizeState check which entry in the state list is more close to x and
%return the index of that entry.

Pr = x(1);
Pb = x(2); 
Vb = x(3);
Vr = x(4);
ro = x(5);
dV = x(6);
gama  = x(7);
fi = x(8);

x(1)=ro;
x(2)=gama;
x(3)=fi;

[as sd]=min(abs(statelist(:,1)-x(1)));
zx=find(statelist(:,1)==statelist(sd,1));

%s=zx;

[as sd]=min(abs(statelist(:,2)-x(2)));
xc=find(statelist(:,2)==statelist(sd,2));

[as sd]=min(abs(statelist(:,3)-x(3)));
cv=find(statelist(:,3)==statelist(sd,3));
 
i1=intersect(zx,xc);
s=intersect(i1,cv);

%s=intersect(zx,xc);
