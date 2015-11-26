function FV = getFeatureVector(X,cores)

m1=cores.mean.ro;
m2=cores.mean.gama;
m3=cores.mean.fi;
m4=cores.mean.vw;

s1=cores.std.ro;
s2=cores.std.gama;
s3=cores.std.fi;
s4=cores.std.vw;

D1=length(m1);
D2=length(m2);
D3=length(m3);
D4=length(m4);

FV=zeros(D1*D2*D3*D4,1);
mf1=zeros(1,D1);
for i=1:D1
    mf1(i) = exp((-0.5*(X(1)-m1(i))^2)/(s1(i)^2));
end
mf2=zeros(1,D2);
for i=1:D2
    mf2(i) = exp((-0.5*(X(2)-m2(i))^2)/(s2(i)^2));
end
mf3=zeros(1,D3);
for i=1:D3
    mf3(i) = exp((-0.5*(X(3)-m3(i))^2)/(s3(i)^2));
end
mf4=zeros(1,D4);
for i=1:D4
    mf4(i) = exp((-0.5*(X(4)-m4(i))^2)/(s4(i)^2));
end


index=1;
for d1=1:D1    
for d2=1:D2
for d3=1:D3
for d4=1:D4
    FV(index,1) = mf1(d1)*mf2(d2)*mf3(d3)*mf4(d4);
    index=index+1;
end
end
end
end
