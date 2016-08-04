function FV = getFeatureVector(X,cores)

m1=cores.mean.x;
m2=cores.mean.xp;
s1=cores.std.x;
s2=cores.std.xp;

D1=length(m1);
D2=length(m2);
FV=zeros(D1*D2,1);

mf1=zeros(1,D1);
for i=1:D1
    mf1(i) = exp((-0.5*(X(1)-m1(i))^2)/(s1(i)^2));
end
mf2=zeros(1,D2);
for i=1:D2
    mf2(i) = exp((-0.5*(X(2)-m2(i))^2)/(s2(i)^2));
end


index=1;
for d1=1:D1    
for d2=1:D2
    FV(index,1) = mf1(d1)*mf2(d2);
    index=index+1;
end
end


