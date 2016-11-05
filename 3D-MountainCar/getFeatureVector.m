function FV = getFeatureVector(X,cores,DRL)

mf1 = exp((-0.5*(X(1)-cores.mean.x).^2)./(cores.std.x.^2));
mf2 = exp((-0.5*(X(2)-cores.mean.xp).^2)./(cores.std.xp.^2));
mf3 = exp((-0.5*(X(3)-cores.mean.y).^2)./(cores.std.y.^2));
mf4 = exp((-0.5*(X(4)-cores.mean.yp).^2)./(cores.std.yp.^2));

index=1;
if DRL==1
    FV=zeros(length(mf1)*length(mf2),2);
    for d1=1:length(mf1)
    for d2=1:length(mf2)
        FV(index,1) = mf1(d1)*mf2(d2);
        FV(index,2) = mf3(d1)*mf4(d2);
        index=index+1;
    end
    end
elseif  DRL==3
    FV=zeros(length(mf1)*length(mf2)*length(mf4),2);
    for d1=1:length(mf1)
    for d2=1:length(mf2)
    for d4=1:length(mf4)
    %for d4=1:length(mf4)
        FV(index,1) = mf1(d1)*mf2(d2)*mf4(d4);
        FV(index,2) = mf3(d1)*mf4(d4)*mf2(d2);
        index=index+1;
    %end
    end
    end
    end
else    
    FV=zeros(length(mf1)*length(mf2)*length(mf3)*length(mf4),1);
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
end

if DRL==2
    FV(:,2) = FV(:,1);
end



