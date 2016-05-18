function f = RUN_SCRIPT(x,RUNS,stringName)
conf.Test=0;

folder = 'final/';

global flagFirst;
global opti;
conf.opti=opti;


conf.episodes = 1000;   % maximum number of  episode
conf.Ts = 0.2; %Sample time of a RL step
conf.maxDistance = 800;    % maximum ball distance permited before to end the episode X FIELD DIMENSION
conf.Runs = RUNS;
conf.NOISE = 0.01;
conf.DRL = x(7); %Decentralized RL(1) or Centralized RL(0)
conf.DRAWS = 1;
conf.record = 1;
conf.fuzzQ = 0;
conf.MAapproach = x(8);

if conf.opti
    conf.DRAWS = 0;
    conf.record = 1;
end



conf.Q_INIT = 0;
conf.EXPL_EPISODES_FACTOR = x(3); %x(1);
RL.param.alpha       = x(4); %x(3);   % learning rate
RL.param.gamma       = 0.99;   % discount factor
RL.param.lambda      = x(6);   % the decaying elegibiliy trace parameter
RL.param.epsilon = 1;
RL.param.softmax = x(5); %x(2);
RL.param.k          = x(1); %x(4);    %1.5 lenience parameter
RL.param.beta       = x(2); %x(5);   %0.9 lenience discount factor

if conf.Test %Para pruebas de performance
    RL.param.epsilon = 0;
    RL.param.softmax = 0;
end 


conf.Pt=[conf.maxDistance/2 0];
conf.posb=[0.5*conf.maxDistance 200];
     

conf.deltaVw = 2;    
conf.Vr_max = [60 5]; %x,y,rot Max Speed achieved by the robot
conf.Vr_min = -conf.Vr_max;
conf.Vr_min(1) = 0;
conf.maxDeltaV = conf.Vr_max.*[1/2 1/2]; %mm/s/Ts
conf.Nactios = [5,5];
if conf.fuzzQ && conf.DRL
    conf.Nactios = [3,3];
end
conf.V_action_steps = (conf.Vr_max-conf.Vr_min)./(conf.Nactios-[1 1]);
conf.Vr_min(1) = 0;
conf.feature_step = [200, 30, 30 conf.V_action_steps(2)]; %[50, 10, 10]  %states
conf.feature_min = [0, -45, -45 conf.Vr_min(2)];
conf.feature_max = [800, 45, 45 conf.Vr_max(2)];

if conf.DRAWS
    size=get(0,'ScreenSize');
    figure('position',[0.1*size(3) 0.05*size(4) 0.85*size(3) 0.7*size(4)]);
end

if conf.MAapproach == 2
   stringName = [stringName '_k' num2str(RL.param.k) '_beta' num2str(RL.param.beta) ];
end
if conf.fuzzQ
    stringName=['fuz-' stringName];
end
if conf.Test
   stringName=['Test-' loadFile]; 
end 
conf.fileName = stringName;

%parfor n=1:RUNS
for n=1:RUNS
    %[reward(:,:,i), e_time(:,i), Vavg(:,i), scored(:,i),  RL] = Dribbling2d( i, conf, RL);
    [pscored(:,n) scored(:, n) Q{n} Qw{n}] = Dribbling2d( n, conf, RL);
end

pf_min=Inf;
pf_max=-Inf;
interval=0.01;

for i=1:RUNS
        
    pf(i) = mean(scored(ceil(interval*conf.episodes):end,i));
    pf_sd(i) = std(scored(ceil(interval*conf.episodes):end,i));
    if pf(i) < pf_min
        pf_min=pf(i);
    end
    if pf(i) > pf_max
        pf_max=pf(i);
        results.Qok_x = Q{i};
        %if conf.DRL
            results.Qok_rot = Qw{i};
        %end
    end
end

results.performance(2,3)=pf_min;
results.performance(1,3)=mean(pf);
results.performance(3,3)=pf_max;
results.performance(4,3)=mean(pf_sd);

f=mean(pf); % Fitness function: percentage of goals scored 

results.mean_goals = mean(pscored,2);
results.std_goals = std(pscored,0,2);

if conf.DRAWS==1
     figure,plot(mean(pscored,2))
     if conf.record > 0
            saveas(gcf,[folder stringName '.fig'])
     end
end

   
if conf.record > 0
   save ([folder stringName '.mat'], 'results');
end
    
% end
% 
% toc




