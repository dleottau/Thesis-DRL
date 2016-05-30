function out=sat(in,satmin,satmax)
if in>satmax
    out=satmax;
elseif in<satmin
    out=satmin;
else
    out=in;
end
