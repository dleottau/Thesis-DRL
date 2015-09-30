function  [accuracy] =Dribbling2d( nRun, conf, RL)
%Dribbling1d SARSA, the main function of the trainning

RL.param.DRL=conf.DRL;

epsilon0     = RL.param.epsilon;  % probability of a random action selection
softmax0     = RL.param.softmax;
 
Ts = conf.Ts; %Sample time of a RL step
[conf.cores, conf.nstates]   = StateTable( conf.feature_min, conf.feature_step, conf.feature_max );  % the table of states
[conf.Actions]  = ActionTable( conf ); % the table of actions

if conf.DRL
    conf.nactions_x    = length(conf.Actions.x);
    conf.nactions_w    = length(conf.Actions.w);
else
    conf.nactions    = size(conf.Actions.cent,1);
end

if conf.DRL
    RL.Q = QTable( conf.nstates, conf.nactions_x, conf );  % the Qtable for the vx agent
    RL.Q_rot = QTable( conf.nstates, conf.nactions_w, conf );  % the Qtable for the v_rot agent
else
    RL.Q = QTable( conf.nstates, conf.nactions, conf ); 
end


EXPLORATION = conf.episodes/conf.EXPL_EPISODES_FACTOR;
epsDec = -log(0.05) * 1/EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios



conf.goalSize = 150;
conf.PgoalPostR = [conf.Pt(1)+conf.goalSize/2 conf.Pt(2)];
conf.PgoalPostL = [conf.Pt(1)-conf.goalSize/2 conf.Pt(2)];
conf.Pr = conf.posr(1,:);
conf.Pb = conf.posb;
conf.Pr(3) = moduloPiDLF(atan2(conf.Pb(2)-conf.Pr(2),conf.Pb(1)-conf.Pr(1)),'r2d'); 

cont=20;
c=0;
points=1;
Npoints=3;
    
for i=1:conf.episodes    
%while points<Npoints
    
    conf.episodeN=i;
    
    [RL, Vr,ro,fi,gama,Pt,Pb,Pbi,Pr,Vb,total_reward,steps,Vavg_k,time,accuracy_] = Episode( RL, conf);
    
    %disp(['Epsilon:',num2str(eps),'  Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
        
    RL.param.epsilon = epsilon0 * exp(-i*epsDec);
    RL.param.softmax = softmax0 * exp(-i*epsDec);
    
    xpoints(i)=i-1;
    reward(i,:)=total_reward/steps;
    e_time(i,1)=steps*Ts;
    Vavg(i,1)=Vavg_k;
    %btd(i,1)=btd_k;
    accuracy(i,1)=accuracy_;
    
    
    if accuracy_
        c=c+1;
    end
    %buff=5;
    
    %if i>buff && prod(accuracy(i-buff:i,1) > 0)
    if c>cont
        %conf.Pr = conf.posr .* clipDLF( ((1+abs( randn(1,3)*(conf.episodeN/conf.episodes)*.1))), 1, ones(1,3)+(conf.episodeN/conf.episodes)*.1);
        %conf.Pr =  clipDLF( conf.posr .* ((1+abs( randn(1,3)*(conf.episodeN/conf.episodes)*1.0))), [conf.maxDistance/2 conf.maxDistance/2 0], [conf.maxDistance conf.maxDistance 180]);
        conf.Pr = conf.posr(randi(size(conf.posr,1)),:);
        conf.Pb = conf.posb; %(randi(size(conf.posb,1)),:);
        conf.Pr(3) = moduloPiDLF(atan2(conf.Pb(2)-conf.Pr(2),conf.Pb(1)-conf.Pr(1)),'r2d'); 
        c=0;
        points=points+1;
    end
    
    
    if conf.DRAWS==1
      
             
        subplot(4,2,1);    
        plot(xpoints,reward(:,1),'r')      
         hold on
         plot(xpoints,reward(:,2),'g')      
%         plot(xpoints,reward(:,3),'b')      
        %plot(xpoints,btd,'k')      
        title([ 'Mean Reward(rgb) Episode:',int2str(i), ' Run: ',int2str(nRun), ' Temp: ', num2str(RL.param.softmax)])
        hold
                
        subplot(4,2,3)
        plot(xpoints,Vavg)
        title('Speed Average')
        %drawnow
        
        subplot(4,2,5); 
        plot(xpoints,e_time)
        title('Episode Time')
        %drawnow
        
        subplot(4,2,7); 
        plot(xpoints,accuracy)
        title('% Accuracy')
        %drawnow
     
        subplot(4,2,2)
        %plot(Pt(1),Pt(2),'*k')%posición del target 
        %hold on
        plot(conf.PgoalPostR(1),conf.PgoalPostR(2),'ok') %goal post right
        hold on
        plot(conf.PgoalPostL(1),conf.PgoalPostL(2),'ok') %goal post Left
        plot(Pb(:,1),Pb(:,2),'*r')%posición de la bola
        plot(Pr(:,1),Pr(:,2),'gx')% posición del robot
        plot(Pbi(1),Pbi(2),'*r') % where ball intersects goal line
        axis([0 conf.maxDistance 0 conf.maxDistance])
        title('X-Y Plane');
        hold
        drawnow
        
        subplot(4,2,6);
        plot(time,ro,'r')
        hold on
        %plot(time,Pr(:,1),'b')
        %plot(time,Pb(:,1),'r*')
        %plot(time,Pb(:,1)-Pr(:,1),'--k')
        title('Position and Pho')
        hold
        drawnow
        
        subplot(4,2,4);
        %plot(time,Vb,'k')
        
        plot(time,Vr(:,1),'r')
        hold on
        plot(time,Vr(:,2),'g')
%         plot(time,Vr(:,3),'b')        
        title('Vr(rgb)')
        hold
        %drawnow
             
%         subplot(4,2,6),plot(time,ro)
%         %axis([time(1) time(steps) 0 1000])
%         title('pho(t)');
        
        subplot(4,2,8);
        plot(time,fi,'g')
        hold on
        plot(time,gama,'b')
        title('phi(t)(g) & gamma(t)(b)');
        %axis([time(1) time(steps) -50 50])
        hold
        drawnow
%         
%         subplot(4,2,9);
%         plot(time,xb,'b')
%         hold on
%         plot(time,yb,'r')
%         plot(time,yfi,'k')
%         title('xb(t)(blue) yb(t)(red) yfi(t)(black)');
%         %axis([time(1) time(steps) -50 50])
%         hold
%         drawnow






%   plot(Pt(1,1),Pt(1,2),'*k')%posición del target 
%         hold on
%         plot(Pb(:,1),Pb(:,2),'*r')%posición de la bola
%         plot(Pr(:,1),Pr(:,2),'g')% posición del robot
%         axis([-100 conf.maxDistance+100 -4000 4000])
%         title('X-Y Plane');
%         hold

%         drawnow
        
     
     end
     
     

end



