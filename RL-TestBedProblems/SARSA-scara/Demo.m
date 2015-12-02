function Demo()
clc
clf;
clear all;
close all;
global TxtEpisode TxtSteps goal f1 f2 grafica
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grid off						% turns on grid
set(gca,'FontSize',7);				
set(gca,'Position',[0.06 0.37 0.75 0.58])	% size of robot windown
subplot(f2)
set(gca,'FontSize',7);
set(gca,'Position',[0.07 0.03 0.9 0.30])	% size of data windown
subplot(f1)
scaraplot(0,0,0,0,[40 3 2],[0,0,0]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(gco,'BackingStore','off')  % for realtime inverse kinematics
set(gco,'Units','data')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         REINFORCEMENT LEARNING LOOP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drawnow;

ScaraDemo(200);


