function x = clipDLF(x,xmin,xmax)

if x < xmin
    x = xmin;
elseif x > xmax
    x = xmax;
end
    