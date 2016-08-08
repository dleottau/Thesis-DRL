function [Pr, Pb, Vb, dirb, ro, gama, fi]=movDiffRobot(dt,Pr,Pt,Pb,Vr,Vb,dirb,Fr,noiseBall)

% Omnidirectional robot Kinematics + pushing a ball
collision=false;inscope=0;
% Pr, global robot pose
% Pb, global ball position
% Vb, ball speed 
% dirb, ball direction
%  ro, robot-ball distance (pho)
% gama, robot-ball angle (gamma)  
% fi, robot-ball-target angle (phi)
% dt, sample time
% Fr, Friction force
% noiseBall, 2D vector to add noise, could be [0,0] for zero noise

    Pb(1)=Pb(1)+cosd(dirb)*Vb*dt;
	Pb(2)=Pb(2)+sind(dirb)*Vb*dt;
	
    if (Vb^2 - Vb*2*Fr*dt > 0)
        Vb = ( Vb^2 - Vb*2*Fr*dt )^0.5;
    else
        Vb=0;
    end
   	
	Pr(1) = Pr(1) + cosd(Pr(3))*Vr(1)*dt + cosd(Pr(3)+90)*Vr(2)*dt;
	Pr(2) = Pr(2) + sind(Pr(3))*Vr(1)*dt + sind(Pr(3)+90)*Vr(2)*dt;
	Pr(3) = Pr(3) + Vr(2)*dt;
	
    Ptr(1) = (Pt(1)-Pr(1))*cosd(Pr(3)) + (Pt(2)-Pr(2))*sind(Pr(3));
	Ptr(2) = (Pt(1)-Pr(1))*cosd(Pr(3)+90) + ((Pt(2)-Pr(2))*sind((Pr(3)+90)));
	
    Pbr(1) = (Pb(1)-Pr(1))*cosd(Pr(3)) + (Pb(2)-Pr(2))*sind(Pr(3));
	Pbr(2) = (Pb(1)-Pr(1))*cosd(Pr(3)+90) + (Pb(2)-Pr(2))*sind(Pr(3)+90);
	
    alfa=atan2(Ptr(2),Ptr(1))*180/pi();
	bet= (Ptr(1)*(Ptr(1)-Pbr(1)) + Ptr(2)*(Ptr(2)-Pbr(2))) / ((Ptr(1)^2+Ptr(2)^2)^0.5 * ((Pbr(1)-Ptr(1))^2+(Pbr(2)-Ptr(2))^2)^0.5);
	if (bet>1), bet=1;
    elseif (bet<-1), bet=-1;
    %elseif isnan(bet), bet=0;
    elseif sum(Pb-Pt)<0.1, bet=0; %particular case where ball y too close to desired target
    end

	beta = acos(bet)*180/pi();
	gama = atan2(Pbr(2),Pbr(1))*180/pi();
	
    if (atan2(Pbr(2),Pbr(1)) < atan2(Ptr(2),Ptr(1)))
	 beta=-beta;
    end
    
    ro = (Pbr(1)^2+Pbr(2)^2)^0.5;
    fi = alfa-beta-gama;
    if gama>=-35 && gama<=35 
        inscope=1;
        if ro<65
            collision=true;
        end
    end
    
%     if inscope==0
%         if ro>40 &&ro<60
%             collision=1;
%         end
%     end

% Here you should include robot-ball collition    
    if collision, %for now, just a cilindrical robot shape with radious 60mm
        Vb = ( abs(Vr(2))+1.5*abs(Vr(1))+78.24*noiseBall(2) ) * cos( dirb*pi()/180-(atan2(0,Vr(1))+Pr(3)*pi()/180) ); 
        %Vb = ( 10*(Vr(2)^2+Vr(1)^2)^0.5 + 78.24*noiseBall(2) ) * cos( dirb*pi()/180-(atan2(Vr(2),Vr(1))+Pr(3)*pi()/180) ) * ((Vr(1)^2+Vr(2)^2)^0.5)/100;
%        dirb = 20*noiseBall(1) + atan2((Pb(2)-Pr(2)),(Pb(1)-Pr(1)))*180/pi();
         %Vb =   cos( dirb*pi()/180-(atan2(Vr(2),Vr(1))+Pr(3)*pi()/180) ) * ((Vr(1)^2+Vr(2)^2)^0.5)/100;
        dirb = 10*noiseBall(1) + 1*Pr(3) + 0.0*atan2((Pb(2)-Pr(2)),(Pb(1)-Pr(1)))*180/pi();
        if (Vb<0), Vb=0; end
    end

	fi = moduloPiDLF(fi,'d2d');
    gama = moduloPiDLF(gama,'d2d');
    dirb=moduloPiDLF(dirb,'d2d');
    Pr(3)=moduloPiDLF(Pr(3),'d2d');
    
     % DEBUG
    if isnan (fi+gama+beta)
            fi
    end  
    % DEBUG
    
end 