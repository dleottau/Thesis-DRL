function i_dist = triang_dist(Vmin,b,Vmax,beta,scale)

r_supp = 1/scale*(Vmax-Vmin)*(1 - beta + 10e-10); %

a = b - r_supp/2;
c = b + r_supp/2;

% Realization from Trianglular PDF.----------------------------------------
u = rand;

% Inverse triangular cumulative distribution.------------------------------
if u == 0
    i_dist = a;
elseif 0 < u && u < (b-a)/(c-a)
    i_dist = a + sqrt( (c-a) * (b-a) * u );
elseif (b-a)/(c-a) <= u && u < 1
    i_dist = c - sqrt( (c-a) * (c-b) * (1-u) );
elseif u == 1
    i_dist = c;
end

% Triangular distribution.-
% if x < a
%     c_dist = 0;
% elseif (a <= x) && (x <= b)
%     c_dist = (x-a)^2 / ( (c-a)*(b-a) );
% elseif (b < x) && (x <= c)
%     c_dist = 1 - (c-x)^2 / ( (c-a)*(c-b) );
% elseif c < x
%     c_dist = 1;
% end