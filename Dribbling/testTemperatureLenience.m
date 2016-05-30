clear all 
clc

k=2;
b=0.95;

k2=2;
b2=0.7;

%x=1:500;

t(1)=1;
t2(1)=1;
for j=2:500
    t(j) = b*t(j-1);
    t2(j) = b2*t2(j-1);
end

plot(1-exp(-k*t),'r')
hold on
%plot(1-exp(-5*k*t),'g')

plot(1-exp(-k2*t2),'b')
%plot(1-exp(-5*k*t2),'k')
title([ int2str(k),'k-',sprintf('%.2f',b),'b' '(r)  ',int2str(k2),'k-',sprintf('%.2f',b2),'b' '(b)'])
hold
