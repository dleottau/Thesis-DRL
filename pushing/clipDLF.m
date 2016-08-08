function cx = clipDLF(x,xmin,xmax)


clip_max = x > xmax;
clip_min = x < xmin;

cx = xmin.*clip_min +  xmax.*clip_max + x .* not(clip_max | clip_min);


    