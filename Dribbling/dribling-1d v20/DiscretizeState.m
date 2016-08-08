function [ s ] = DiscretizeState( x, statelist )
%DiscretizeState check which entry in the state list is more close to x and
%return the index of that entry.

Pr = x(1);
Pb = x(2); 
Vb = x(3);
Vr = x(4);

ro = Pb-Pr;
dV = Vb-Vr;
x(1)=ro;
x(2)=dV;

[as sd]=min(abs(statelist(:,1)-x(1)));
zx=find(statelist(:,1)==statelist(sd,1));

%[as sd]=min(abs(statelist(:,2)-x(2)));
%xc=find(statelist(:,2)==statelist(sd,2));

% [as sd]=min(abs(statelist(:,3)-x(3)));
% cv=find(statelist(:,3)==statelist(sd,3));
% 
% i1=intersect(zx,xc);
% s=intersect(i1,cv);

%s=intersect(zx,xc);
s=zx;