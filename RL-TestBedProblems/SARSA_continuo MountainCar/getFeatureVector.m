function FV = getFeatureVector(X,cores)

% m1=cores.mean.x;
% m2=cores.mean.y;
% m3=cores.mean.xp;
% m4=cores.mean.yp;
% 
% s1=cores.std.x;
% s2=cores.std.y;
% s3=cores.std.xp;
% s4=cores.std.yp;

% D1=length(m1);
% D2=length(m2);
% D3=length(m3);
% D4=length(m4);
% 
% FV=zeros(D1*D2,1);


mf1 = exp((-0.5*(X(1)-cores.mean.x).^2)./(cores.std.x.^2));
mf2 = exp((-0.5*(X(2)-cores.mean.y).^2)./(cores.std.y.^2));
mf3 = exp((-0.5*(X(3)-cores.mean.xp).^2)./(cores.std.xp.^2));
mf4 = exp((-0.5*(X(4)-cores.mean.yp).^2)./(cores.std.yp.^2));

FV=zeros(length(mf1)*length(mf2)*length(mf3)*length(mf4),1);



% mf1=zeros(1,D1);
% for i=1:D1
%     mf1(i) = exp((-0.5*(X(1)-m1(i))^2)/(s1(i)^2));
% end
% mf2=zeros(1,D2);
% for i=1:D2
%     mf2(i) = exp((-0.5*(X(2)-m2(i))^2)/(s2(i)^2));
% end


index=1;
for d1=1:length(mf1)
for d2=1:length(mf2)
for d3=1:length(mf3)
for d4=1:length(mf4)
    FV(index,1) = mf1(d1)*mf2(d2)*mf3(d3)*mf4(d4);
    index=index+1;
end
end
end
end


