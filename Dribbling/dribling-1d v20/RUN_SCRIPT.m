clear all
episodes = 100;   % maximum number of  episode
maxDistance = 6000;    % maximum ball distance permited before to end the episode
ro_max = 500;      % maximum pho desired
Runs = 20;
NOISE = 0.0;  % Nivel de ruido, entre 0 y 1
tic

a_spot={'r' 'g' 'b' 'c' 'm' 'y' 'k' '--r' '--g' '--b' '--c' };

mf_min=Inf;
cr_max=-Inf;
v_max=-Inf;
pf_min=Inf;

mf_max=-Inf;
cr_min=Inf;
v_min=Inf;
pf_max=-Inf;
  
for i=1:Runs
%    disp(['Test= ', num2str(a), '.', num2str(i), ' lambda= ', num2str(lambda(a))])
    [reward(:,i) fitness(:,i) Vavg(:,i) tp_faults(:,i) Q] = Dribbling1d(episodes,maxDistance,ro_max,NOISE);
    
    mf(i) = mean(fitness(floor(0.9*episodes):episodes,i));
    if mf(i) < mf_min
        mf_min=mf(i);
        Qok=Q;
    end
    if mf(i) > mf_max
        mf_max=mf(i);
    end
       
    vm(i) = mean(Vavg(floor(0.9*episodes):episodes,i));
    if vm(i) > v_max
        v_max=vm(i);
    end
    if vm(i) < v_min
        v_min=vm(i);
    end
        
    pf(i) = mean(tp_faults(floor(0.9*episodes):episodes,i));
    if pf(i) < pf_min
        pf_min=pf(i);
    end
    if pf(i) > pf_max
        pf_max=pf(i);
    end
    
    cr(i) = mean(reward(floor(0.9*episodes):episodes,i));
    if cr(i) > cr_max
        cr_max=cr(i);
        mf_xxx=mf(i);
        v_xxx=vm(i);
        pf_xxx=pf(i);
    end
    if cr(i) < cr_min
        cr_min=cr(i);
    end
    
end


results(3,1)=v_min;
results(1,1)=mean(vm);
results(2,1)=v_max;

results(2,2)=mf_min;
results(1,2)=mean(mf);
results(3,2)=mf_max;

results(2,3)=pf_min;
results(1,3)=mean(pf);
results(3,3)=pf_max;

results(3,4)=cr_min;
results(1,4)=mean(cr);
results(2,4)=cr_max;

results(4,4)=cr_max;
results(4,3)=pf_xxx;
results(4,2)=mf_xxx;
results(4,1)=v_xxx;

save Qok;
save results;

 
%figure,plot(mean(reward,2))
% figure,plot(mean(fitness,2))
% figure,plot(mean(Vavg,2))

 
toc

%Con lambda=0.0: mf_mean=1.4945e+03; mf_min=1.4417e+03; Converge en 85 episodios
%Con lambda=0.2: mf_mean=1.6140e+03; mf_min=1.4878e+03; Converge en 35 episodios
%Con lambda=0.5: mf_mean=1.5578e+03; mf_min=1.3660e+03; Converge en 10 episodios
%Con lambda=0.9: mf_mean=1.5922e+03; mf_min=1.3443e+03; Converge en 10 episodios


%fitness final con 5 acciones y dV +/- = 1.2811e+03
%fitness final con 10 acciones y dV +/- = 1.1919e+03
%fitness final con 10 acciones s(pho) = 1.4716e+03  %1120 con el 90%
%fitness final con 5 acciones s(pho) = 1.4274e+03   %1420 con el 90% 