function Demo()
clc
clf;
%clear all;
close all;
global TxtEpisode TxtSteps goal f1 f2 grafica



param.MAapproach = 2;%x(4);   % 0 no cordination, 1 frequency adjusted, 2 leninet
param.record = 0;
param.DRAW = 1;
param.maxsteps = 400;  % maximum number of steps per episode
grafica = 0; % enables 3D graph
param.alpha      = 0.3;    % Learning rate
param.gamma      = 1;      % discount factor
param.epsilon    = 0.01;   % probability of a random action selection
param.softmax    = 1;%x(1);   % Boltzmann temperature (50 by default), if <= 0 e-greaddy
param.k          = 1.5;%x(2);   %1.5 lenience parameter
param.beta       = 0.9;%x(3);   %0.9 lenience discount factor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if param.DRAW
    f1 = subplot(2,1,1);
    f2 = subplot(2,1,2);
    grafica = false;
    subplot(f1);
    P2 = ['setgrafica();'];
    PushBut2=uicontrol(gcf,'Style','togglebutton','Units','normalized', ...
        'Position',[0.83 .9 0.16 0.05],'string','Graficar', ...
          'Callback',P2,'visible','on','BackgroundColor',[0.8 0.8 0.8]);
    set(gcf,'name','Reinforcement Learning with a Scara Manipulator Robot');
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


disp(['SCARA Robot'])
f=ScaraDemo(100, param);
disp(['Fitness: ', num2str(f) , '%'])
