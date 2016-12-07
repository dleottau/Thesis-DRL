function  [pscored, scored, Qx, Qw, elapsedTime] = Dribbling2d( nRun, conf, RL)
%Dribbling1d SARSA, the main function of the trainning

set(gcf,'name',['Differential Robot ' conf.fileName])
RL.param.DRL=conf.DRL;

epsilon0     = RL.param.epsilon;  % probability of a random action selection
softmax0     = RL.param.softmax;

Ts = conf.Ts; %Sample time of a RL step
cores   = StateTable( conf.feature_min, conf.feature_step, conf.feature_max);  % the table of states
conf.cores=cores;
conf.nstates   = length(cores.mean.ro)*length(cores.mean.gama)*length(cores.mean.fi)*length(cores.mean.vw);
nsVx=length(cores.mean.ro)*length(cores.mean.gama)*length(cores.mean.fi);
conf.nstatesD   = [nsVx, conf.nstates];

[conf.Actions]  = ActionTable( conf ); % the table of actions

if conf.DRL
    conf.nactions_x    = length(conf.Actions.x);
    conf.nactions_w    = length(conf.Actions.w);
else
    conf.nactions    = size(conf.Actions.cent,1);
end

if ~conf.Test
    if conf.DRL && conf.jointState
        RL.Q = QTable( conf.nstates, conf.nactions_x, conf.Q_INIT );  % the Qtable for the vx agent
        RL.Q_rot = QTable( conf.nstates, conf.nactions_w, conf.Q_INIT );  % the Qtable for the v_rot agent
    elseif conf.DRL % individual states
        RL.Q = QTable( conf.nstatesD(1), conf.nactions_x, conf.Q_INIT );  % the Qtable for the vx agent
        RL.Q_rot = QTable( conf.nstatesD(2), conf.nactions_w, conf.Q_INIT );  % the Qtable for the v_rot agent
    else
        RL.Q = QTable( conf.nstates, conf.nactions, conf.Q_INIT ); 
        RL.Q_rot = 0;
    end
end

RL.T        = 0;
RL.T_rot    = 0;
if conf.MAapproach == 2 && conf.DRL 
    if conf.jointState
        RL.T        = QTable( conf.nstates,conf.nactions_x, 1);
        RL.T_rot    = QTable( conf.nstates, conf.nactions_w, 1 );
    else
        RL.T        = QTable( conf.nstatesD(1),conf.nactions_x, 1);
        RL.T_rot    = QTable( conf.nstatesD(2), conf.nactions_w, 1 );
    end
end

EXPLORATION = conf.episodes./conf.EXPL_EPISODES_FACTOR;
epsDec = -log(0.05) * 1./EXPLORATION;  %epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios

RL.param.fuzzQ = conf.fuzzQ;

conf.goalSize = 150;
conf.PgoalPostR = [conf.Pt(1)+conf.goalSize/2 conf.Pt(2)];
conf.PgoalPostL = [conf.Pt(1)-conf.goalSize/2 conf.Pt(2)];

   
for i=1:conf.episodes    
conf.episodeN=i;
   while 1
        conf.Pb = conf.posb;
        if ~conf.Test
            uB=[conf.maxDistance conf.maxDistance 180];
            lB=[0 0.5*conf.maxDistance -180];
            conf.Pr = rand(1,3).*(uB-lB) + lB;
            %conf.Pr(3) = moduloPiDLF(atan2(conf.Pb(2)-conf.Pr(2),conf.Pb(1)-conf.Pr(1)),'r2d'); 
            [~,~,~,~, pho, gamma, phi]=movDiffRobot(Ts, conf.Pr, conf.Pt, conf.Pb, [0 0],0,0,0,zeros(2,1));
            if ~sum([pho abs(gamma) abs(phi)]>1.1*conf.feature_max(1:3))
                break
            end
        else
            uB=[0.9*conf.maxDistance 1*conf.maxDistance 180];
            lB=[0.1*conf.maxDistance 0.7*conf.maxDistance -180];
            conf.Pr = rand(1,3).*(uB-lB) + lB;
            [~,~,~,~, pho, gamma, phi]=movDiffRobot(Ts, conf.Pr, conf.Pt, conf.Pb, [0 0],0,0,0,zeros(2,1));
            if ~sum([pho abs(gamma) abs(phi)]>conf.feature_max(1:3).*[1 0.25 0.9])
                break
            end
        end
    end
    
    
    [RL, Vr,ro,fi,gama,Pt,Pb,Pbi,Pr,Vb,total_reward,steps,Vavg_k,time,scored_,conf] = Episode( RL, conf);
    
      
    RL.param.epsilon = epsilon0 .* exp(-i*epsDec);
    RL.param.softmax = softmax0 .* exp(-i*epsDec);
    
    xpoints(i)=i-1;
    reward(i,:)=total_reward/steps;
    e_time(i,1)=steps*Ts;
    Vavg(i,1)=Vavg_k;
    %btd(i,1)=btd_k;
    scored(i)=scored_;
    pscored(i,1)=mean(scored);
    
        
    if conf.DRAWS==1
             
%         subplot(4,2,1);    
%         plot(xpoints,reward(:,1),'r')      
%          hold on
%          plot(xpoints,reward(:,2),'g')      
% %         plot(xpoints,reward(:,3),'b')      
%         %plot(xpoints,btd,'k')      
%         title([ 'Mean Reward(rgb) Episode:',int2str(i), ' Run: ',int2str(nRun), ' Temp: ', num2str(RL.param.softmax)])
%         hold
%                 
%         subplot(4,2,3)
%         plot(xpoints,Vavg)
%         title('Speed Average')
%         %drawnow
%         
%         subplot(4,2,5); 
%         plot(xpoints,e_time)
%         title('Episode Time')
%         %drawnow
%         
%         subplot(4,2,7); 
%         plot(xpoints,pscored)
%         title('% goals scored')
%         %drawnow
%      
%         subplot(4,2,2)
%         %plot(Pt(1),Pt(2),'*k')%posición del target 
%         %hold on
%         plot(conf.PgoalPostR(1),conf.PgoalPostR(2),'ok') %goal post right
%         hold on
%         plot(conf.PgoalPostL(1),conf.PgoalPostL(2),'ok') %goal post Left
%         plot(Pb(:,1),Pb(:,2),'*r')%posición de la bola
%         plot(Pr(:,1),Pr(:,2),'gx')% posición del robot
%         plot(Pbi(1),Pbi(2),'*r') % where ball intersects goal line
%         axis([0 conf.maxDistance 0 conf.maxDistance])
%         title('X-Y Plane');
%         hold
%         drawnow
%         
%         subplot(4,2,6);
%         plot(time,ro,'r')
%         hold on
%         %plot(time,Pr(:,1),'b')
%         %plot(time,Pb(:,1),'r*')
%         %plot(time,Pb(:,1)-Pr(:,1),'--k')
%         title('Pho')
%         hold
%         drawnow
%         
%         subplot(4,2,4);
%         %plot(time,Vb,'k')
%         
%         plot(time,Vr(:,1),'r')
%         hold on
%         plot(time,Vr(:,2),'g')
% %         plot(time,Vr(:,3),'b')        
%         title('Vr(rg)')
%         hold
%         %drawnow
%              
%        
%         subplot(4,2,8);
%         plot(time,fi,'g')
%         hold on
%         plot(time,gama,'b')
%         title('phi(t)(g) & gamma(t)(b)');
%         %axis([time(1) time(steps) -50 50])
%         hold
%         drawnow




                    
        
        subplot(1,2,2); 
        plot(xpoints,pscored)
        title('% goals scored')
        %drawnow
     
        subplot(1,2,1)
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
        
        
        
     
     end
     
     

end

Qx=RL.Q;
Qw=RL.Q_rot;
elapsedTime=conf.timeCounter;

if ~conf.opti
    disp(['RUN: ' int2str(nRun) '; cumGoals: ',num2str(pscored(end))]);
end



