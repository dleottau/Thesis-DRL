function  [pscored, scored, dist_BT, Qx, Qy, Qw] = Dribbling2d( nRun, conf, RL )

% Dribbling1d SARSA, the main function of the trainning

RL.param.DRL = conf.DRL;

epsilon0 = RL.param.epsilon;  % Probability of a random action selection
softmax0 = RL.param.softmax;
p0       = 1;
Ts       = conf.Ts;           % Sample time of a RL step

[conf.cores, conf.nstates, conf.div_disc] = StateTable( conf.feature_min, conf.feature_step, conf.feature_max );   % The table of states
[conf.Actions]                            = ActionTable( conf );                                                   % The table of actions

if conf.DRL
    conf.nactions_x = length(conf.Actions.x);
    % ---------------------------------------------------------------------
    conf.nactions_y = length(conf.Actions.y);
    % ---------------------------------------------------------------------
    conf.nactions_w = length(conf.Actions.w);
else
    conf.nactions   = size(conf.Actions.cent,1);
end

if ~conf.Test
    if conf.DRL
        RL.Q     = QTable( conf.nstates, conf.nactions_x, conf.Q_INIT );   % The Qtable for the vx agent
        % -----------------------------------------------------------------
        RL.Qy    = QTable( conf.nstates, conf.nactions_y, conf.Q_INIT );   % The Qtable for the vy agent
        % -----------------------------------------------------------------
        RL.Q_rot = QTable( conf.nstates, conf.nactions_w, conf.Q_INIT );   % The Qtable for the v_rot agent
    else
        RL.Q     = QTable( conf.nstates, conf.nactions, conf.Q_INIT );
        % -----------------------------------------------------------------
        RL.Qy    = 0;
        % -----------------------------------------------------------------
        RL.Q_rot = 0;
    end
end

% -------------------------------------------------------------------------
if conf.TRANSFER >= 0
    RL.Q         = QTable( conf.nstates,conf.nactions_x, conf.Q_INIT );  % the Qtable for the vx agent
    RL.Qy        = QTable( conf.nstates, conf.nactions_y, conf.Q_INIT );   % The Qtable for the vy agent
    RL.Q_rot     = QTable( conf.nstates, conf.nactions_w, conf.Q_INIT );   % The Qtable for the v_rot agent
    
    RL.trace     = QTable( conf.nstates,conf.nactions_x,0 );  % the elegibility trace for the vx agent
    RL.trace_y   = QTable( conf.nstates,conf.nactions_y,0 );  % the elegibility trace for the vx agent
    RL.trace_rot = QTable( conf.nstates,conf.nactions_w,0 );  % the elegibility trace for the vx agent
end
% -------------------------------------------------------------------------

RL.T     = 0;
RL.T_y   = 0;
RL.T_rot = 0;

if conf.MAapproach == 2
    RL.T     = QTable( conf.nstates, conf.nactions_x, 1 );
    RL.T_y   = QTable( conf.nstates, conf.nactions_y, 1 );
    RL.T_rot = QTable( conf.nstates, conf.nactions_w, 1 );
end

% ------------------------------------------------------
if conf.TRANSFER < 0    % Para pruebas de performance
    epsilon0 = 0;
    p0       = 0;
    softmax0 = 0;
end
% ------------------------------------------------------

% ----------------------------------------------------------------------- %
EXPLORATION = abs(conf.episodes/RL.param.exp_decay);
% ----------------------------------------------------------------------- %
epsDec      = -log(0.05) * 1/EXPLORATION;  % Epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios.-

% ------------------------------------------------
RL.param.fuzzQ  = conf.fuzzQ;
% ------------------------------------------------
RL.param.M       = conf.Mtimes;
RL.param.epsilon = abs(epsilon0);
RL.param.p       = p0;
RL.break         = 0;
RL.caFlag=0;
RL.minPap=0;
% -----------------------------------------------

for i = 1:conf.episodes
    conf.episodeN = i;
    
    if conf.TRANSFER > 1,
        RL.param.p = 1;         % Acts greedy from source policy
    elseif conf.TRANSFER == 0,
        RL.param.p = 0;         % Learns from scratch
    end                         % Else Transfer from source decaying as p
    
    % -----------------------
    conf.checkGoal = 0;
    % -----------------------
    
    while 1
        if ~conf.Test
            uB      = [conf.Pb(1)+900   conf.Pb(2)+1200   180];       % uB = [conf.Pb(1)+1000 conf.Pb(2)+1000  180];
            lB      = [conf.Pb(1)-1100  conf.Pb(2)-1200  -180];       % lB = [conf.Pb(1)+ 00 conf.Pb(2)-1000 -180];
            conf.Pr = rand(1,3).*(uB-lB) + lB;                        % conf.Pr = rand(1,3).*(uB-lB) + lB;                             
            
            %conf.Pr    = [conf.Pb(1)+1000 conf.Pb(2) 180];
            %conf.Pr(3) = moduloPiDLF(atan2(conf.Pb(2)-conf.Pr(2),conf.Pb(1)-conf.Pr(1)),'r2d') + (rand-.5)*(5);                       
            
            %% Robot movement.---------------------------------------------
            [~, ~, ~, ~, phi, gamma, pho, ~, ~, ~] = mov(Ts,conf.Pr,conf.Pt,conf.Pb,0,0,0,100,100,100,0,0,conf.Fr,zeros(2,1));
            % -------------------------------------------------------------
            
            if (pho <= conf.r_ext && conf.r_int <= pho) && (abs(phi) < conf.c_ang) && (abs(gamma) < 30)            
            %if (pho <= conf.r_ext && conf.r_int <= pho) && (abs(phi) < 40) && (abs(gamma) < 5)            
                break
            end
        else 
            %             uB         = [conf.Pb(1)+1000 conf.Pb(2)+1000  180];
            %             lB         = [conf.Pb(1)-1000 conf.Pb(2)-1000 -180];
            %             conf.Pr    = rand(1,3).*(uB-lB) + lB;
            %
            %             % conf.Pr    = [conf.Pb(1)+800 conf.Pb(2) 180];
            %             % conf.Pr(3) = moduloPiDLF(atan2(conf.Pb(2)-conf.Pr(2),conf.Pb(1)-conf.Pr(1)),'r2d');
            %
            %             %% Robot movement.---------------------------------------------
            %             [~, ~, ~, ~, phi, gamma, pho, ~, ~, ~] = mov(Ts,conf.Pr,conf.Pt,conf.Pb,0,0,0,100,100,100,0,0,conf.Fr,zeros(2,1));
            %             % -------------------------------------------------------------
            %
            %             if (pho <= conf.r_ext && conf.r_int <= pho) && (abs(phi) < conf.c_ang) && (abs(gamma) < 30)
            %                 break
            %             end
            
            uB         = [conf.Pb(1)+1000 conf.Pb(2)+1000  180];
            lB         = [conf.Pb(1)-1000 conf.Pb(2)-1000 -180];
            % conf.Pr    = rand(1,3).*(uB-lB) + lB;
            
            conf.Pr    = [conf.Pb(1)+800 conf.Pb(2) 180];
            conf.Pr(3) = moduloPiDLF(atan2(conf.Pb(2)-conf.Pr(2),conf.Pb(1)-conf.Pr(1)),'r2d');
            
            % Robot movement.---------------------------------------------
            [~, ~, ~, ~, phi, gamma, pho, ~, ~, ~] = mov(Ts,conf.Pr,conf.Pt,conf.Pb,0,0,0,100,100,100,0,0,conf.Fr,zeros(2,1));
            % -------------------------------------------------------------
            
            if (pho <= conf.r_ext && conf.r_int <= pho) && (abs(phi) < conf.c_ang) && (abs(gamma) < 45)
                break
            end
        end
    end
    
    %% Se ejecuta la rutina Episode.-
    [RL, Vr,ro,fi,gama,Pt,Pb,Pbi,Pr,Vb,total_reward,steps,Vavg_k,time,scored_,f_shoot] = Episode( RL, conf );
    
    %dec = exp(-i*epsDec);
    %dec = exp(-i*epsDec)*(1+cos(2*pi*i*10/EXPLORATION))/2;
    dec = exp(-i*RL.param.exp_decay/conf.episodes);
    %keyboard
    
    RL.param.epsilon = abs(epsilon0) * dec;
    RL.param.p       = p0*dec;
    if softmax0>0,     RL.param.softmax = abs(softmax0) * dec; end
    
    xpoints(i)   = i-1;                                        %#ok<*AGROW>
    reward(i,:)  = total_reward/steps;
    e_time(i,1)  = steps*Ts;                                   %#ok<*NASGU>
    Vavg(i,1)    = Vavg_k;
    scored(i,1)    = scored_;
    caAvg(i,:)=RL.param.caAvg/steps;
    dpaAvg(i,:)=RL.param.dpaAvg/steps;
    TDAvg(i,:)=RL.TDAvg/steps;
    
        
    if i > conf.episodes*0.1;
        pscored(i,1) = mean(scored(i-conf.episodes*0.1:i));
    else
        pscored(i,1) = mean(scored);
    end
    
    DEC(i) = RL.param.softmax;    
    % ---------------------------------------------------------------------
    
    dist_BT(i) = 100 * (sqrt((Pb(end,1) - Pt(1))^2 + (Pb(end,2) - Pt(2))^2)) / norm(conf.Pb - conf.Pt);
    
    if 100 <= dist_BT(i)
        dist_BT(i) = 100;
    end
    if dist_BT(i) <= 0
        dist_BT(i) = 0;
    end
    
    RL.break = min(dist_BT) > 50 && i > conf.episodes/2;    % && conf.opti;  % PARA ACELERAR OPTIMIZACIÓN, si no converge antes de 700 episodios, no seguir entrenando
    % ---------------------------------------------------------------------
    
    %% Training plot.------------------------------------------------------
    if conf.DRAWS1 == 1
        
        subplot(2,3,5);
        plot(caAvg*RL.param.alpha)
%          hold on
%          plot(TDAvg)
%          hold off
        title('alphaAvg')
        
        subplot(2,3,4);
        plot(RL.CA)
%          hold on
%          plot(RL.TD)
%          hold off
        title('CA per step')
        %ylim([0 1])
        grid
        %title('.5*ro.b fi.r gama.y')
        
        
        subplot(2,3,3)
        plot(reward)
        grid
        title('Reward')
        
        subplot(2,3,6)
        plot(smooth( dist_BT, 0.04,'rloess'),'k','LineWidth',2)
        ylim([0 110])
        grid
        title('Distance Ball-Target')
        
        % Score Plot.------------------------------------------------------
        subplot(2,3,2);
        plot(xpoints,pscored)
        grid
        title('% Goals Scored')
        % -----------------------------------------------------------------
                
        % Robot Movement Plot.----------------------------------------
        subplot(2,3,1) %[1,4]
        
        plot(conf.PgoalPostR(1),conf.PgoalPostR(2),'ok','MarkerFaceColor',[0 0 0],'LineWidth',4)   % Goal post right
        hold on
        plot(conf.PgoalPostL(1),conf.PgoalPostL(2),'ok','MarkerFaceColor',[0 0 0],'LineWidth',4)   % Goal post Left
        line([conf.PgoalPostR(1) conf.PgoalPostL(1)],[conf.PgoalPostR(2) conf.PgoalPostL(2)],'Color',[0.5 0.5 0.5],'LineWidth',2)
        
        line([conf.PgoalPostR(1) conf.Pb(1)],[conf.PgoalPostR(2) conf.Pb(2)],'Color',[0.5 0.5 0.5],'LineWidth',2)
        line([conf.PgoalPostL(1) conf.Pb(1)],[conf.PgoalPostL(2) conf.Pb(2)],'Color',[0.5 0.5 0.5],'LineWidth',2)                
        
        if scored_
            line([conf.PgoalPostR(1) conf.PgoalPostL(1)],[conf.PgoalPostR(2) conf.PgoalPostL(2)],'Color',[0 1 0],'LineWidth',4)
        end
        
        view(90,90)
        plot(Pb(:,1),Pb(:,2),'*r','MarkerSize',8,'LineWidth',4)  % Ball Position
        plot(Pr(:,1),Pr(:,2),'bx','MarkerSize',8,'LineWidth',4)  % Robot Positions
        xlim([-conf.maxDistance_x/30 conf.maxDistance_x/3.5])
        ylim([-conf.maxDistance_y/2 conf.maxDistance_y/2])
        
        
        
        grid
        % -----------------------------------------------------------------       
        
        % Circle plot.-----------------------------------------------------
        h_figur = gcf;
        %circle_plot(conf.Pt(1), conf.Pt(2), conf.a3, conf.b3, conf.r3, 0, 2 * pi, h_figur, 'k',2);
        circle_plot(conf.PgoalPostR(1), conf.PgoalPostR(2), conf.a3, conf.b3, 50, 0, 2 * pi, h_figur, 'k',2);
        circle_plot(conf.PgoalPostL(1), conf.PgoalPostL(2), conf.a3, conf.b3, 50, 0, 2 * pi, h_figur, 'k',2);
        
        [xci1,xci2,yci1,yci2] = circle_plot(conf.Pb(1), conf.Pb(2), 1, 1, conf.r_int, -conf.c_ang * pi / 180, conf.c_ang * pi / 180, h_figur, 'c',1);
        [xce1,xce2,yce1,yce2] = circle_plot(conf.Pb(1), conf.Pb(2), 1, 1, conf.r_ext, -conf.c_ang * pi / 180, conf.c_ang * pi / 180, h_figur, 'c',1);
        plot([xci1 xce1],[yci1 yce1],'c')
        plot([xci2 xce2],[yci2 yce2],'c')
        % -----------------------------------------------------------------
        
        title('X-Y Plane');
        hold off
        drawnow
        
        if scored_;
            % keyboard
        end        
    end
end

% -------------------------
Qx = RL.Q;
% -------------------------
Qy = RL.Qy;
% -------------------------
Qw = RL.Q_rot;
% -------------------------

if ~conf.opti
disp(['RUN: ' int2str(nRun) '; FailedGoals: ',num2str(100-pscored(end))]);
% disp(['RUN: ' int2str(nRun) '; cumGoals: ',num2str(dist_BT)]);
end