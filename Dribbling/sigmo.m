function [y]= sigmo(x,med,dev)

y=1/( 1 + exp( dev * (x-med) ) );