function cx = clipDLF(x,xmin,xmax)


clip_max = x > xmax;
clip_min = x < xmin;

cx = xmin.*clip_min +  xmax.*clip_max + x .* not(clip_max | clip_min);

%cx = xmin.*clip_min + xmax.*clip_max + x .* not(clip_max & clip_min);

% if x < xmin
%     x = xmin;
% elseif x > xmax
%     x = xmax;
% end
    