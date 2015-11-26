mu    = [0 0];
sigma = [250 0 ; 0 1500];
f_gmm = @(x,y)mvnpdf([x y],mu,sigma);

x1      = -150:0.5:150; x2 = -150:.5:150;
[X1,X2] = meshgrid(x1,x2);

figure(1)
ezsurf(f_gmm,X1,X2)
figure(2)
ezcontour(f_gmm,X1,X2)
grid