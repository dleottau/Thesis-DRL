clear all
clc
clf
close all

%folder = 'opti/CoSh/test03/';
%folder = 'opti/NeASh/test303/';
folder = 'opti/NeASh/triang1Sat03/';

sort_1f_0t=0;


record=0;
thT=20; % threshold to time to threshold
interval=0.7;
%m=1;


files = dir(fullfile([folder '*.mat']));
f=[];
j=1;
for i=1:size(files,1)
    result=importdata([folder files(i).name]);
%     rth = find(result.<th);
%     if ~isempty(rth) && length(rth)>=m
%         time_th=rth(m);
%     else time_th=inf;
%     end
    gf=0.5*(100-result.mean_Vavg+result.mean_faults);
    Tth=result.conf.episodes;
    if thT>=min(gf)
        tth=find(gf<thT);
        Tth=tth(1);
    end
    result.performance(1,6)=Tth;
    
    if record
        save([result.stringName], 'results');
    end

    results1{i}.name=files(i).name;
    results1{i}.Tth=Tth;
    %results1{i}.f=result.performance(1,3);
    results1{i}.f = mean(gf(ceil(interval*length(gf)):end));
    
    f(i)=results1{i}.f;
    t(i)=results1{i}.Tth;
    clear result gf;
end

if sort_1f_0t
    [v,index]=sort(f);
    for i=1:size(files,1)
        resultsSummary{i}=results1{index(i)};
        disp(resultsSummary{i}.name);
        disp(['Fitness=' num2str(resultsSummary{i}.f) '; T_th=' int2str(resultsSummary{i}.Tth)]);
        disp(' ');
    end
else
    [v,index]=sort(t);
    for i=1:size(files,1)
        resultsSummary{i}=results1{index(i)};
        disp(resultsSummary{i}.name);
        disp(['T_th=' int2str(resultsSummary{i}.Tth) '; Fitness=' num2str(resultsSummary{i}.f) ]);
        disp(' ');
    end
end

     
