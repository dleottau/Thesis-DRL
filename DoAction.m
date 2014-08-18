function [xp x_obs] = DoAction(action, xp, Ts, w, V_FLC, NOISE, Voffset, ); 
%DribblingDoAction: executes the action (a) into the dribbling1d
%environment




% Updating kinematincs model 
    Vyr(i,1) = V_FLC(2);
    Vtheta(i,1) = V_FLC(3);
    %Vyr(i,1)=0;
    %Vtheta(i,1)=0;
    
    % ADDING NOISE
    Vr=Vxr(i-1,1); %current x speed
    %action = V_FLC(1); % Enables the FLC of Vx
    dVelReq = action - Vr;
    
    % Vro is the observed speed, without noise
    Vro = action;
    
    % TODO: Extender esta saturación para Vy y Vtheta
    if abs(dVelReq)>maxDeltaVx
        Vr = Vr + sign(dVelReq)*maxDeltaVx;
    else
        Vr = Vr + dVelReq;
    end
    
    Vr = Vr*(clipDLF(1+0.3*randn(), 1-NoiseRobotVel, 1+NoiseRobotVel)); 
    Vr = clipDLF(Vr,Voffset,Vxrmax); 
    Vxr(i,1)=Vr;
    
    
    [Pr(i,:) Ptr(i,:) Pbr(i,:) alfa(i,1) fi(i,1) gama(i,1) ro(i,1) Vb(i,1) dirb(i,1) Pb(i,:)]=mov(Ts,Pr(i-1,:),Pt,Pb(i-1,:),Vxr(i,1),Vyr(i,1),Vtheta(i,1),Vxrmax,Vyrmax,Vthetamax,Vb(i-1,1),dirb(i-1,1),Fr,randn(2,1)*NoiseBall);
    dV(i,1) = Vb(i,1) * cosd( Pr(i,3)-dirb(i,1) ) - Vxr(i,1);
      
    % Ground thruth state vector
    xp = [Pr(i,1),Pb(i,1),Vb(i,1),Vxr(i,1),ro(i,1),dV(i,1),gama(i,1),fi(i,1)];

    % Observed state vector xo
    %Adding noise to the ball and target perceptions
    np = (rand()*2*NoisePerception - NoisePerception) + 1;
    x_obs = xp * np;
    x_obs(1) = xp(1); % x position of the robot , not influenced by noise in perceptions
    x_obs(4) = Vro; % x speed of the robot , not influenced by noise in perceptions
















Pr = x(1);
Pb = x(2); 
Vb = x(3);
Vr = x(4);

Fr = 150;

Vr = Vr + action;

Vr = Vr + NoiseRobotVel*Vr*randn(1,1);
    if Vr<Voffset
        Vr = Voffset;
    elseif Vr>100
        Vr = 100;
    end

[Pr Pb Vb]=mov1d(Pr,Pb,Vb,Vr,dt,Fr,NoiseBall);
 
ro = Pb-Pr;
xp=[Pr Pb Vb Vr];



