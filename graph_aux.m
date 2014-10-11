%load 'results_Learn_T-D-RL'
t=results.mean_eTime;
f=results.mean_faults;

mT = [t(1:200); t(601:700);  t(201:500); t(216:315); t(501:1500); t(1301:1400); t(1361:1460); t(1401:1500)  ];

mF = [f(1:200); f(601:700);  f(201:500); f(216:315); f(501:1500); f(1301:1400); f(1361:1460); f(1401:1500)  ];


figure
subplot(1,2,1);    
plot(mT)
title('Episode Time')

subplot(1,2,2)
plot(mF)
title('% Faults')
