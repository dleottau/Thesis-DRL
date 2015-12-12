function f=Demo(x, RUNS,stringFile,opti)
%clc
%clf;
%clear all;
%close all;
%TxtEpisode; TxtSteps; goal; f1; f2; grafica;

folder = 'finalTests/'; 
%folder = 'opti/'; 

param.MAapproach = x(6);   % 0 no cordination, 1 frequency adjusted, 2 leninet
param.record = 1;
param.DRAW = 0;
param.maxepisodes = 100; % number of episode to be run
param.maxsteps = 400;  % maximum number of steps per episode
grafica = 0; % enables 3D graph
param.alpha      = x(2);    % 0.3 Learning rate
param.epsilon    = x(3);   % 0.01 probability of a random action selection
param.gamma      = x(5);      % 1 discount factor
param.k          = x(1);   %1.5 lenience parameter
param.beta       = x(4);   %0.9 lenience discount factor
param.softmax    = param.k;   % Boltzmann temperature (50 by default), if < 0 e-greaddy

if param.epsilon >= 0
    stringFile=['e-greedy-' stringFile];
else
    stringFile=['softmax-' stringFile];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=0;
f2=0;

if opti
    param.record = 1;
    param.DRAW = 0;
end

if param.DRAW
    f1 = subplot(2,1,1);
    f2 = subplot(2,1,2);
    grafica = false;
    subplot(f1);
    P2 = ['setgrafica();'];
    PushBut2=uicontrol(gcf,'Style','togglebutton','Units','normalized', ...
        'Position',[0.83 .9 0.16 0.05],'string','Graficar', ...
          'Callback',P2,'visible','on','BackgroundColor',[0.8 0.8 0.8]);
    set(gcf,'name',['SCARA DRL - ' stringFile]);
    set(gcf,'Color','w')


    grid off						% turns on grid
    set(gca,'FontSize',7);				
    set(gca,'Position',[0.06 0.37 0.75 0.58])	% size of robot windown
    subplot(f2)
    set(gca,'FontSize',7);
    set(gca,'Position',[0.07 0.03 0.9 0.30])	% size of data windown
    subplot(f1)
    scaraplot(0,0,0,0,[40 3 2],[0,0,0]);
    
    set(gco,'BackingStore','off')  % for realtime inverse kinematics
    set(gco,'Units','data')
    
    drawnow;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         REINFORCEMENT LEARNING LOOP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parfor i=1:RUNS
%for i=1:RUNS
    [f_i(i), cumSteps(:,i)]=ScaraDemo(param, f1, f2, grafica);
end
cumSteps=100*cumSteps/param.maxsteps;
cumSteps_mean = mean(cumSteps,2);
cumSteps_std = std(cumSteps,0,2);
f=mean(f_i);

if ~opti
    disp(['Fitness: ', num2str(f) , '%'])
end

results.f_i=f_i;
results.f=f;
results.cumSteps=cumSteps;
results.cumSteps_mean=cumSteps_mean;
results.cumSteps_std=cumSteps_std;

if param.DRAW
    size=get(0,'ScreenSize');
    figure('position',[0.5*size(3) 0.1*size(4) 0.5*size(3) 0.7*size(4)]);
    set(gcf,'name',['SCARA Robot ' stringFile])
    plot(cumSteps_mean)
end


if param.record
    save ([folder stringFile  '.mat'], 'results');
end

if ~opti
    disp(['Fitness:',num2str(f),'%; ']);
end

