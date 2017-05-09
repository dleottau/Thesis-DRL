function [ RL, Vr,ro,fi,gama,Pt,Pb,Pbi,Pr,Vb,total_reward,steps,Vavg,time,scored,f_shoot] = Episode(RL, conf)
% Dribbling1d do one episode with sarsa learning
% maxDistance : the maximum number of steps per episode
% Q           : the current QTable
% alpha       : the current learning rate
% gamma       : the current discount factor
% epsilon     : probablity of a random action
% statelist   : the list of states
% actionlist  : the list of actions

%% Dribbling2d with SARSA
Vr_max         = conf.Vr_max;    % x,y,rot Max Speed achieved by the robot
Vr_min         = conf.Vr_min;
maxDeltaV      = conf.maxDeltaV; % mm/s/Ts
% th_max = conf.th_max;
Ts             = conf.Ts;
NOISE          = conf.NOISE;
maxDistance    = conf.maxDistance;
V_action_steps = conf.V_action_steps;

RL.param.pa = [1/conf.nactions_x, 1/conf.nactions_y, 1/conf.nactions_w];
RL.param.ca = RL.param.pa;
RL.param.dpa = [0, 0, 0];
RL.param.dpaAvg = [0, 0, 0];
RL.param.caAvg = [0, 0, 0];
RL.TDAvg = [0, 0, 0];
RL.CA = zeros(3);
RL.DPA = zeros(3);
RL.TD = zeros(3);

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
[RL.V_src] = controller_dribbling (xG,Vr_min,Vr_max,conf.Controller);

ballState = 0;

% Selects an action
a     = 1;
a_y   = 1;
a_rot = 1;

U               = 1;
Qv              = 0;
RL.param.fa     = 0;
updateSarsaFlag = 1;

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
        % -----------------------------------------------------------------
        
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
    
    %% ADDING SATURATONS AND NOISE
    if conf.flag_Vr == 1
        Vr_req(1) = action;
        % -------------------------------------------------------------
        Vr_req(2) = action_y;
        % -------------------------------------------------------------
        Vr_req(3) = action_rot;
        % -------------------------------------------------------------
    else
        Vr_req = RL.V_src;
    end
    
    % Ball state = [0 stoped, 1 accelerating, 2 deaccelerating, 3 stoped after it was moved]
    if ballState ~= 0
        Vr_req          = [0,0,0];
        updateSarsaFlag = 0;        % do not update SARSA until ball stops
    end
    
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
        ballState       = 3;                % Ball stops after it moves
        updateSarsaFlag = 1;                % Last update SARSA
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
    [RL.V_src] = controller_dribbling (Xp,Vr_min,Vr_max,conf.Controller);
    % ---------------------------------------
    
    %% Check if it is a Goal.----------------------------------------------
    balline               = Pb(i,:);
    [conf.checkGoal, Pbi] = goal1( conf , balline );
    
    %% Observe the reward at state xp and the final state flag.------------
    [r,f,f_shoot] = GetReward(Xp, Pr(i,:), Pb(i,:), Pt, conf.checkGoal, Pbi, ballState, conf);
    total_reward     = total_reward + r;
    
    if f
        updateSarsaFlag = 1;
    end
    
    % Select action prime
    [a_sc, Pap] = p_source_selection2(RL,FVp,conf);
    ap     = a_sc(1);
    ap_y   = a_sc(2);
    ap_rot = a_sc(3);
        
    % --------------------------------------------------------------------
        
    % Frequency adjusted param
        %pap = [min(Pap), min(Pap), min(Pap)];
        [vsp, index]=sort(Pap,'descend');
        vsp=sort(Pap);
        pap(index)=vsp;
        
        cap = clipDLF(pap,0.05,1);
          
        if conf.MAapproach==1;
            cap = 1-cap;
        elseif conf.MAapproach==4
            if min(Pap)> RL.minPap, 
                RL.minPap=min(Pap);  
                min(Pap)
                conf.episodeN
            end
            if min(Pap)>=1 && RL.caFlag==0  %0.99999
                RL.caFlag=1;
                conf.episodeN
            end
            if RL.caFlag==1, cap = 1-cap; end
        end
        
    % select MA approach
    if conf.MAapproach==0 || conf.MAapproach==2
        pap=[1 1 1];
        cap=pap;
    end
    
    RL.param.caAvg = RL.param.ca + RL.param.caAvg;
    RL.param.dpa = Pap-RL.param.pa;
    RL.param.dpaAvg = RL.param.dpa + RL.param.dpaAvg;
        
    % Update the Qtable, that is,  learn from the experience
    if ~conf.Test && updateSarsaFlag
        if conf.DRL                                                                                                                 % Decentralized
            [RL.Q_rot, trace_rot, TD(3)] = UpdateSARSA(FV, a_rot, r(2), FVp, ap_rot, RL.Q_rot, trace_rot, RL.param, RL.T_rot, conf.MAapproach, RL.param.ca(3));
            % -------------------------------------------------------------
            [RL.Qy, trace_y, TD(2)] = UpdateSARSA(FV, a_y, r(2), FVp, ap_y, RL.Qy, trace_y, RL.param, RL.T_y, conf.MAapproach, RL.param.ca(2));
            % -------------------------------------------------------------
            if conf.fuzzQ                                                                                                           % Fuzzy Q learning
                [ RL.Q, trace, U, Qv] = UpdateQfuzzy(FV, r(1), RL.Q, trace, RL.param, Qv);
            else                                                                                                                    % SARSA
                [RL.Q, trace, TD(1)] = UpdateSARSA(FV, a, r(1), FVp, ap, RL.Q, trace, RL.param, RL.T, conf.MAapproach, RL.param.ca(1));
            end
        else % Centralized
            [RL.Q, trace, TD] = UpdateSARSA(FV, a, r(1), FVp, ap, RL.Q, trace, RL.param, RL.T, conf.MAapproach, RL.param.ca(1));
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
    RL.param.ca = .5*(RL.param.ca+cap);
    RL.param.pa = Pap;
    RL.CA(steps,1)=RL.param.ca(1); 
    RL.CA(steps,2)=RL.param.ca(2);
    RL.CA(steps,3)=RL.param.ca(3);
    RL.DPA(steps,1)=RL.param.dpa(1); 
    RL.DPA(steps,2)=RL.param.dpa(2); 
    RL.DPA(steps,3)=RL.param.dpa(3); 
    RL.TD(steps,:) = TD;
    RL.TDAvg = RL.TDAvg + TD;
    % Compute performance index
    Vrx    = xG(4);
    pho_   = xG(5);
    gamma_ = xG(7);
    phi_   = xG(8);
    Vavg   = xG(1)/time(i);
    
    % Terminal state?
    if ( f == true || time(i) > 200 || RL.break)
        if conf.checkGoal
            scored = 100;   % 100*(1-abs(Pbi(1)-Pt(1))/(conf.goalSize/2));
        end
        break
    end
end
end