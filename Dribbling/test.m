k=2;
b=0.95;
b2=0.99;
x=1:2000;
t(1)=1;
t2(1)=1;
for j=2:2000
    t(j) = b*t(j-1);
    t2(j) = b2*t2(j-1);
end

plot(1-exp(-k*t),'r')
hold on
plot(1-exp(-5*k*t),'g')

plot(1-exp(-k*t2),'b')
plot(1-exp(-5*k*t2),'k')
title([ '2k.95b(r) 10k.95b(g) 2k.99b(b) 10k.99b(b)'])

hold
