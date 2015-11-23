mu = [0 0;0 0];
sigma = cat(3,[300 0;0 300],[400 0;0 8000]);
p = [0.3 0.7];
obj = gmdistribution(mu,sigma,p);

x1 = -150:0.5:150; x2 = -150:.5:150;
[X1,X2] = meshgrid(x1,x2);

figure(1)
ezsurf(@(x,y)pdf(obj,[x y]),X1,X2)
figure(2)
ezcontour(@(x,y)pdf(obj,[x y]),X1,X2)
grid 

f_gmm = @(x,y)pdf(obj,[x y])