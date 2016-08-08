function a = sourcePolicy(x,a_target,p)
   
if x(2)>=0, a_source=3;
else a_source=1;
end


if (rand() >= p) 
    a = a_target; 
else
    a = a_source;
end

