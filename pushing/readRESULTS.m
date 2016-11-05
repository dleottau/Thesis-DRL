clear all
clc
clf
close all

sort_1f_0t = 0;  % sort by best fitness (0) or by fastest convergence (1)
thT = 30; % threshold to time to threshold from 0-100%

folder = 'opti/';
%folder = 'final/Delft/';


record=0;
interval=0.999;
m=1;
span=0.00001;

files = dir(fullfile([folder '*.mat']));
f=[];
j=1;
for i=1:size(files,1)
    
    result=importdata([folder files(i).name]);
       
    F = result.mean_goals;
    %Tth=result.performance(1,2);
    
    F = smooth(result.mean_goals, span,'rloess');
     Tth = size(F,1);
     %keyboard
     if sum(F>thT) && (sum(F<thT)>m)
         tth=find(F>thT);
         Tth=tth(m);
     end
       
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
    [v,index]=sort(t);
    for i=1:size(files,1)
        resultsSortFast{i}=results1{index(i)};
    end
    [v,index]=sort(resultsSortFast,'descend');

    [v,index]=sort(f,'descend');
for i=1:size(files,1)
        resultsSortBest{i}=results1{index(i)};
end

resultsSort=resultsSortBest;
if ~sort_1f_0t
    [v,index]=sort(t);
    for i=1:size(files,1)
        resultsSortBest{i}=resultsSort{index(i)};
        disp(resultsSortBest{i}.name);
        disp(['T_th=' int2str(resultsSortBest{i}.Tth) '; Fitness=' num2str(resultsSortBest{i}.f) ]);
        disp(' ');
    end
end

for i=1:size(files,1)
 if ~sort_1f_0t
            disp(resultsSortBest{i}.name);
            disp(['Fitness=' num2str(resultsSortBest{i}.f) '; T_th=' int2str(resultsSortBest{i}.Tth)]);
            disp(' ');
        end
end
     
