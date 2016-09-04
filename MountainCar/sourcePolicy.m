function a = sourcePolicy(x,a_target,transfer,RLparam)

p=RLparam.p;
scale=RLparam.scale;

rnd=randn();
if transfer==2 %nash
    x=x+scale*rnd*(1-RLparam.p);
end


 
if x(2)>=0, a_source=3;
else a_source=1;
end

a = a_target;
if transfer
    if p >= rand()
       a = a_source;
    else
       a = a_target;
    end
end
    
