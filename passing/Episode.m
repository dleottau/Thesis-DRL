function [ RL, Vr,ro,fi,gama,Pt,Pb,Pbi,Pr,Vb,total_reward,steps,Vavg,time,scored] = Episode(RL, conf)
% Dribbling1d do one episode with sarsa learning
% maxDistance : the maximum number of steps per episode
% Q           : the current QTable
% alpha       : the current learning rate
% gamma       : the current discount factor
% epsilon     : probablity of a random action
% statelist   : the list of states
% actionlist  : the list of actions

%% Dribbling2d with SARSA
Vr_max      = conf.Vr_max;    % x,y,rot Max Speed achieved by the robot
Vr_min      = conf.Vr_min;
maxDeltaV   = conf.maxDeltaV; % mm/s/Ts
% th_max = conf.th_max;
Ts          = conf.Ts;
NOISE       = conf.NOISE;
maxDistance = conf.maxDistance;

if conf.DRL
    actionlist_x = conf.Actions.x;
    % ---------------------------------------------------------------------
    actionlist_y = conf.Actions.y;
    % ---------------------------------------------------------------------
    actionlist_w = conf.Actions.w;
else
    actionlist = conf.Actions.cent;
end

trace = 0*RL.Q;  % the elegibility trace for the vx agent

if conf.DRL
    % ---------------------------------------------------------------------
    trace_y = 0*RL.Qy;  % the elegibility trace for the v_rot agent
    % ---------------------------------------------------------------------
    trace_rot = 0*RL.Q_rot;  % the elegibility trace for the v_rot agent
end

Pr = conf.Pr;
Pb = conf.Pb;
Pt = conf.Pt;

% NoiseRobotVel   = [NOISE * 0.15 NOISE * 0.03];
% -------------------------------------------------------------------------
NoiseRobotVel   = [NOISE * 0.15  NOISE * 0.15  NOISE * 0.03];
% -------------------------------------------------------------------------
NoiseBall       = [0.0 ; 0] + NOISE * 0.8;           %  0.70
NoisePerception = NOISE * 0.0025;

% ------------- INIT PARAMETERS ---------------------
total_reward = 0;
time(1)      = 0;
i            = 1;
Vavg         = 0;
scored       = 0;
Fr           = conf.Fr;

% ---------------------------------------------------------------------
Vr(i,:)   = [0 0 0];                                        % Robot Velocity
% ---------------------------------------------------------------------

Vb(i,1)   = 0;                                              % Ball Velocity
dirb(i,1) = atan2(Pb(i,2)-Pr(i,2),Pb(i,1)-Pr(i,1))*180/pi;  % Ball Direction

%% Robot movement.---------------------------------------------------------
[Pr(i,:), Ptr(i,:), Pbr(i,:), alfa, fi(i,1), gama(i,1), ro(i,1), Vb(i,1), dirb(i,1), Pb(i,:)] = mov(Ts,Pr,Pt,Pb,Vr(i,1),Vr(i,2),Vr(i,3),100,100,100,Vb,dirb,Fr, clipDLF(randn(2,1).*NoiseBall,-2,2));

% ---------------------------------------------------------------------
dBT(i) = norm(Pb(i,:) - Pt,2);
% ---------------------------------------------------------------------

dVb   = 0;
xG    = [Pr(i,1),Pb(i,2),Vb(i,1),Vr(i,1),ro(i,1),dVb,gama(i,1),fi(i,1),Pt(1,1),Pr(i,2),Pb(i,1),Pr(i,3),Vr(i,2),Vr(i,3),dBT(i)];
x_obs = xG;
X     = [x_obs(5), x_obs(7), x_obs(8) x_obs(15)];
X     = clipDLF(X, conf.feature_min, conf.feature_max);
% =========================================================================

FV = getFeatureVector(X, conf.cores);

% Get velocity from Linear Controller
[V_FLC] = controller_dribbling (xG,Vr_min,Vr_max);

ballState = 0;

% Selects an action
[a  , p]       = action_selection(RL.Q     , RL.T     , FV, RL.param);
[a_y , p_y]    = action_selection(RL.Qy    , RL.T_y   , FV, RL.param);
[a_rot, p_rot] = action_selection(RL.Q_rot , RL.T_rot , FV, RL.param);


U           = 1;
Qv          = 0;
RL.param.fa = 0;

while 1
    steps   = i;
    i       = i+1;              % OJO, ESTO ES IMPORTANTE PUES SE EVALUAN ESTADOS ANTERIORES, i-1
    time(i) = time(i-1) + Ts;
    
    % Convert the index of the action into an action value
    if conf.DRL
        action     = actionlist_x(a);
        % -----------------------------------------------------------------
        action_y   = actionlist_y(a_y);
        % -----------------------------------------------------------------
        action_rot = actionlist_w(a_rot);
        if conf.fuzzQ
            if conf.Test
                MF       = FV/sum(FV);
                [qv, av] = max(RL.Q,[],2);
                U        = sum( MF .* av);
            end
            action   = (U-1) * conf.V_action_steps(1);
            % -------------------------------------------------------------
            action_y = (U-1) * conf.V_action_steps(2);
            % -------------------------------------------------------------
        end
    else
        action     = actionlist(a,1);
        % -------------------------------------------------------------
        action_y   = actionlist(a,2);
        % -------------------------------------------------------------
        action_rot = actionlist(a,3);   % actionlist(a,2);
    end
    
    % ----------------------------- DO ACTION -----------------------------
    % do the selected action and get the next state
    
    % ADDING SATURATONS AND NOISE
    Vr_req(1) = action;
    % -------------------------------------------------------------
    Vr_req(2) = action_y;
    % -------------------------------------------------------------
    Vr_req(3) = action_rot;
    % Vr_req(2) = Vr(i-1,2) + action_rot;
    % -------------------------------------------------------------
    
    % Ball state = [0 stoped, 1 accelerating, 2 deaccelerating, 3 stoped after it was moved]
    if ballState ~= 0
        %  if ballState == 3
        % -----------------------------------------------------------------
        Vr_req = [0,0,0];
        % -----------------------------------------------------------------
    end
    
    % Enables linear controller
    % Vr_req(1) = V_FLC(1);
    % Vr_req(2) = V_FLC(2);
    
    % Add Noise =========
    % Vr is the current robot speed
    dVelReq = Vr_req - Vr(i-1,:);
    
    % Vro is the observed speed, without noise
    % Vro = action;
    
    saturation = abs(dVelReq) > maxDeltaV;
    Vr(i,:)    = Vr(i-1,:) + sign(dVelReq).*saturation.*maxDeltaV + not(saturation).*dVelReq;
    
    % Adding noise in the walking speed, request vs actuator
    Vr(i,:) = Vr(i,:).*(clipDLF(1+0.3*randn(), 1-NoiseRobotVel, 1+NoiseRobotVel));
    % Clip Vx into the permited range
    Vr(i,:) = clipDLF(Vr(i,:),Vr_min,Vr_max);
    % =====================================================================
    
    %% Updating kinematincs model
    [Pr(i,:), Ptr(i,:), Pbr(i,:), alfa, fi(i,1), gama(i,1), ro(i,1), Vb(i,1), dirb(i,1), Pb(i,:)] = mov(Ts,Pr(i-1,:),Pt,Pb(i-1,:),Vr(i,1),Vr(i,2),Vr(i,3),100,100,100,Vb(i-1,1),dirb(i-1,1),Fr, clipDLF(randn(2,1).*NoiseBall,-2,2));
    
    % ---------------------------------------------------------------------
    dBT(i,:) = norm(Pb(i,:) - Pt,2);
    % ---------------------------------------------------------------------
    
    dVb = (Vb(i)-Vb(i-1));
    
    if dVb > 2
        ballState = 1;                      % Accelerating
    elseif dVb < -2
        ballState = 2;                      % Deaccelerating
    elseif ballState == 2 && Vb(i,1) < 2
        ballState = 3;                      % Ball stops after it moves
    end
    
    % Ground truth state vector
    % ---------------------------------------------------------------------
    xG = [Pr(i,1),Pb(i,2),Vb(i,1),Vr(i,1),ro(i,1),dVb,gama(i,1),fi(i,1),Pt(1,1),Pr(i,2),Pb(i,1),Pr(i,3),Vr(i,2),Vr(i,3),dBT(i)];
    % ---------------------------------------------------------------------
    
    % Adding noise to the ball and target perceptions
    np = (rand()*2*NoisePerception - NoisePerception) + 1;
    
    % Observed state vector x_obs
    x_obs    = xG * np;
    x_obs(1) = xG(1);           % x position of the robot , not influenced by noise in perceptions
    x_obs(4) = Vr_req(1);       % x speed of the robot , not influenced by noise in perceptions
    
    Xp  = [x_obs(5), x_obs(7), x_obs(8), x_obs(15)];
    Xp  = clipDLF(Xp, conf.feature_min, conf.feature_max);
    FVp = getFeatureVector(Xp, conf.cores);
    
    % Get velocity From Linear Controller
    [V_FLC] = controller_dribbling (Xp,Vr_min,Vr_max);
    % ---------------------------------------
    
    %% Check if it is a Goal.----------------------------------------------
    balline          = Pb(i,:);
    [checkGoal, Pbi] = goal1( conf , balline , ballState );
    
    %% Observe the reward at state xp and the final state flag.------------
    [r,f]        = GetReward(Xp, Pr(i,:), Pb(i,:), Pt, checkGoal, Pbi, ballState, conf);
    total_reward = total_reward + r;    
    
    % keyboard
    
    %% --------------------------------------------------------------------
    % ----------------------------------------------------------------%
    % Esto no va.-
    % sp  = DiscretizeStateDLF(x_obs,conf.cores,conf.feature_step,conf.div_disc);
    % ----------------------------------------------------------------%
    
    % select action prime
    %ap = e_greedy_selection(RL.Q , sp, RL.param.epsilon);
    
    %a_transf = GetBestAction(RL.Qs,sp);
    a_transf     = 1 + round(V_FLC(1)/conf.V_action_steps(1));  % from FLC
    % a_transf     = 1 + round(V_FLC'/conf.V_action_steps(1));  % from FLC
    a_transf_y   = 1 + round(V_FLC(2)/conf.V_action_steps(2) + Vr_max(2)/conf.V_action_steps(2) );
    a_transf_rot = 1 + round(V_FLC(3)/conf.V_action_steps(3) + Vr_max(3)/conf.V_action_steps(3) );
    
    if conf.sync.nash > 0
        rnd.nash     = randn();
        rnd.nashExpl = randn();
    end
    if conf.sync.expl > 0
        rnd.expl = rand();
    end
    if conf.sync.TL > 0
        rnd.TL = rand();
    end
    
    [ap, fa_x]       = p_source_selection_FLC(RL.Q     , RL.T     , FVp , RL.param , a_transf     , conf.nash , conf.sync , rnd);
    [ap_y, fa_y]     = p_source_selection_FLC(RL.Q_y   , RL.T_y   , FVp , RL.param , a_transf_y   , conf.nash , conf.sync , rnd);
    [ap_rot, fa_rot] = p_source_selection_FLC(RL.Q_rot , RL.T_rot , FVp , RL.param , a_transf_rot , conf.nash , conf.sync , rnd);
    %% --------------------------------------------------------------------
    
        
    % Select action prime
    [ap, fa] = action_selection(RL.Q, RL.T, FVp, RL.param);
    if conf.DRL
        [ap_rot, fa_rot] = action_selection(RL.Q_rot, RL.T_rot, FVp, RL.param);
        % -----------------------------------------------------------------
        [ap_y, fa_y]     = action_selection(RL.Qy, RL.T_y, FVp, RL.param);
        % -----------------------------------------------------------------
        
        fap = 1;
        if conf.MAapproach == 1
            fap = 1-min([(fa-1/conf.nactions_x), (fa_y-1/conf.nactions_y), (fa_rot-1/conf.nactions_w)])+1E-3;
        elseif conf.MAapproach == 3
            fap = min([(fa-1/conf.nactions_x), (fa_y-1/conf.nactions_y), (fa_rot-1/conf.nactions_w)])+1E-3;
        end
        fap = clipDLF(fap, 0, 1);
    end
    
    
    % Update the Qtable, that is,  learn from the experience
    if ~ conf.Test
        if conf.DRL                                                                                                                 % Decentralized
            [RL.Q_rot, trace_rot] = UpdateSARSA(FV, a_rot, r(2), FVp, ap_rot, RL.Q_rot, trace_rot, RL.param, RL.T_rot, conf.MAapproach);
            % -------------------------------------------------------------
            [RL.Qy, trace_y] = UpdateSARSA(FV, a_y, r(2), FVp, ap_y, RL.Qy, trace_y, RL.param, RL.T_y, conf.MAapproach);
            % -------------------------------------------------------------
            if conf.fuzzQ                                                                                                           % Fuzzy Q learning
                [ RL.Q, trace, U, Qv] = UpdateQfuzzy(FV, r(1), RL.Q, trace, RL.param, Qv);
            else                                                                                                                    % SARSA
                [RL.Q, trace] = UpdateSARSA(FV, a, r(1), FVp, ap, RL.Q, trace, RL.param, RL.T, conf.MAapproach);
            end
        else % Centralized
            [RL.Q, trace] = UpdateSARSA(FV, a, r(1), FVp, ap, RL.Q, trace, RL.param, RL.T, conf.MAapproach);
        end
    end
    
    % Update the current variables
    X = Xp;
    a = ap;
    
    if conf.DRL
        % -----------------------------------------------------------------
        a_y = ap_y;
        % -----------------------------------------------------------------
        a_rot = ap_rot;
    end
    FV          = FVp;
    RL.param.fa = fap;
    
    % Compute performance index
    Vrx    = xG(4);
    pho_   = xG(5);
    gamma_ = xG(7);
    phi_   = xG(8);
    Vavg   = xG(1)/time(i);
    
    % Terminal state?
    if ( f == true || time(i) > 100 )
        if checkGoal
            scored = 100;   % 100*(1-abs(Pbi(1)-Pt(1))/(conf.goalSize/2));
        end
        break
    end
end
end