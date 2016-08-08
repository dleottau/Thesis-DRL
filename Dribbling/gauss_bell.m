function [y]= gauss_bell(x,med,dev)

y=exp( -0.5 * ((x-med).^2)/dev^2 ) +0.0000000000000000001;