clear all
clc
clf
close all

sort_1f_0t = 1;  % sort by best fitness (0) or by fastest convergence (1)
thT = 55; % threshold to time to threshold from 0-100%

folder = 'opti/';
%folder = 'opti/drl/test1/';

record=0;
interval=0.7;
m=10;
span=0.1;

files = dir(fullfile([folder '*.mat']));
f=[];
j=1;
for i=1:size(files,1)
    
    result=importdata([folder files(i).name]);
       
    F = result.mean_dbt;
    Tth=result.performance(1,2);
    
    %F = smooth(result.mean_goals, span,'rloess');
    %Tth = size(F,1);
    %keyboard
    %if sum(F<thT) && (sum(F<thT)>m)
    %    tth=find(F<thT);
    %    Tth=tth(m);
    %end
       
    if record
        save([result.stringName], 'results');
    end

    results1{i}.name=files(i).name;
    results1{i}.Tth=Tth;
    %results1{i}.f=result.performance(1,1);
    results1{i}.f = mean(F(ceil(interval*length(F)):end));
    
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

     
