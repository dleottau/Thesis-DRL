function  [pscored, scored, Qx, Qy, Qw] = Dribbling2d( nRun, conf, RL )
% function  [pscored, scored, Qx, Qy, Qw, score_out] = Dribbling2d( nRun, conf, RL )
% function  [pscored, scored, Qx, Qw, score_out] = Dribbling2d( nRun, conf, RL )

% Dribbling1d SARSA, the main function of the trainning

RL.param.DRL = conf.DRL;

epsilon0     = RL.param.epsilon;  % Probability of a random action selection
softmax0     = RL.param.softmax;

Ts = conf.Ts;                     % Sample time of a RL step

[conf.cores, conf.nstates] = StateTable( conf.feature_min, conf.feature_step, conf.feature_max );   % The table of states
[conf.Actions]             = ActionTable( conf );                                                   % The table of actions

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
        RL.Q     = QTable( conf.nstates, conf.nactions_x, conf );   % The Qtable for the vx agent
        % -----------------------------------------------------------------
        RL.Qy    = QTable( conf.nstates, conf.nactions_y, conf );   % The Qtable for the vy agent
        % -----------------------------------------------------------------
        RL.Q_rot = QTable( conf.nstates, conf.nactions_w, conf );   % The Qtable for the v_rot agent
    else
        RL.Q     = QTable( conf.nstates, conf.nactions, conf );
        % -----------------------------------------------------------------
        RL.Qy    = QTable( conf.nstates, conf.nactions, conf );
        % -----------------------------------------------------------------
        RL.Q_rot = 0;
    end
end

EXPLORATION = conf.episodes/conf.EXPL_EPISODES_FACTOR;
epsDec      = -log(0.05) * 1/EXPLORATION;  % Epsilon decrece a un 5% (0.005) en maxEpisodes cuartos (maxepisodes/4), de esta manera el decrecimiento de epsilon es independiente del numero de episodios.-

RL.param.fuzzQ  = conf.fuzzQ;
conf.goalSize   = 150;
conf.PgoalPostR = [conf.Pt(1)+conf.goalSize/2 conf.Pt(2)]; % Right Goal Post position
conf.PgoalPostL = [conf.Pt(1)-conf.goalSize/2 conf.Pt(2)]; % Left Goal Post position

% keyboard

for i = 1:conf.episodes
    conf.episodeN = i;
    while 1
        conf.Pb = conf.posb;
        if ~conf.Test
            uB      = [conf.maxDistance conf.maxDistance 180];
            lB      = [0 0.6 * conf.maxDistance -180];
            conf.Pr = rand(1,3).*(uB-lB) + lB;
            
            % conf.Pr    = [conf.maxDistance/2 0.7 * conf.maxDistance 180];
            % conf.Pr(3) = moduloPiDLF(atan2(conf.Pb(2)-conf.Pr(2),conf.Pb(1)-conf.Pr(1)),'r2d');
            
            %% Movimiento Robot.-
            % -------------------------------------------------------------
            [~,~,~,~, pho, gamma, phi] = movDiffRobot(Ts, conf.Pr, conf.Pt, conf.Pb, [0 0 0],0,0,0,zeros(2,1));
            % -------------------------------------------------------------
                        
            % Revisar esta parte (inicialización Robot)
            if ~sum([pho abs(gamma) abs(phi)] > 1.1*conf.feature_max(1:3))
                break
            end
        else
            uB                         = [0.9 * conf.maxDistance 1.0 * conf.maxDistance 180];
            lB                         = [0.1 * conf.maxDistance 0.7 * conf.maxDistance -180];
            conf.Pr                    = rand(1,3).*(uB-lB) + lB;
            % -------------------------------------------------------------
            [~,~,~,~, pho, gamma, phi] = movDiffRobot(Ts, conf.Pr, conf.Pt, conf.Pb, [0 0 0],0,0,0,zeros(2,1));
            % -------------------------------------------------------------
            
            if ~sum([pho abs(gamma) abs(phi)] > conf.feature_max(1:3).*[1 0.25 0.9])
                break
            end
        end
    end
    
    %% Se ejecuta la rutina Episode.-
    [RL, Vr,ro,fi,gama,Pt,Pb,Pbi,Pr,Vb,total_reward,steps,Vavg_k,time,scored_,score_zone] = Episode( RL, conf );
    
%     if isempty(score_zone) ~= 1
%         score_out(conf.cE,:) = score_zone;
%         conf.cE              = conf.cE + 1;
%     end
    
    RL.param.epsilon = epsilon0 * exp(-i*epsDec);
    RL.param.softmax = softmax0 * exp(-i*epsDec);
    
    xpoints(i)   = i-1;
    reward(i,:)  = total_reward/steps;
    e_time(i,1)  = steps*Ts;
    Vavg(i,1)    = Vavg_k;
    scored(i)    = scored_;
    pscored(i,1) = mean(scored);
    
    % keyboard
    %% Plot del entrenamiento.-
    % Se agrega el plot del círculo.-
    if conf.DRAWS == 1
        subplot(1,3,3)
        plot(reward)
        grid
        
        % Gráfico score.---------------------------------------------------
        subplot(1,3,2);
        plot(xpoints,pscored)
        grid
        title('% goals scored')
        % -----------------------------------------------------------------
        
        % Gráfico movimiento robot.----------------------------------------
        subplot(1,3,1)
        plot(Pt(1),Pt(2),'.k','LineWidth',2)                % Posición del target
        hold on
        plot(Pb(:,1),Pb(:,2),'*r')                          % Posición de la bola
        plot(Pr(:,1),Pr(:,2),'gx')                          % Posición del robot
        axis([0 conf.maxDistance 0 conf.maxDistance])
        grid
        % -----------------------------------------------------------------
        
        % Gráfico elipses.-------------------------------------------------
        h_figur = gcf;
        
        circle_plot(conf.Pt(1), conf.Pt(2), conf.a1, conf.b1, conf.r1, conf.tx1, conf.ty1, h_figur, 'b')
        circle_plot(conf.Pt(1), conf.Pt(2), conf.a3, conf.b3, conf.r3, conf.tx3, conf.ty3, h_figur, 'k')
        % -----------------------------------------------------------------
        
        title('X-Y Plane');
        hold off
        drawnow
    end
end

Qx = RL.Q;
% -----------------------------------------------------------------
Qy = RL.Qy;
% -----------------------------------------------------------------
Qw = RL.Q_rot;

if ~conf.opti
    disp(['RUN: ' int2str(nRun) '; cumGoals: ',num2str(pscored(end))]);
end