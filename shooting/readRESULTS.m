clear all
clc
%clf
%close all

sort_1f_0t = 1;  % sort by best fitness (0) or by fastest convergence (1)
thT = 40; % threshold to time to threshold from 0-100%

%folder = 'Opti/neash/lq/';
%folder = 'Opti/cosh/hq/';
%folder = 'Opti/DRL/Fr5/';
folder = 'tests/';

record=0;
interval=0.7;
m=1;
%span=0.000001;

files = dir(fullfile([folder '*.mat']));
f=[];
j=1;
for i=1:size(files,1)
    
    result=importdata([folder files(i).name]);
    F = result.mean_goals;
    %Tth=result.performance(1,2);
    Tth = size(F,1);
     if sum(F>thT) && (sum(F>thT)>m)
         tth=find(F>thT);
         Tth=tth(m);
     end
       
    if record
        save([result.stringName], 'results');
    end

    name{i}=files(i).name;
    %resFT(i,1) = result.performance(1,1);
    %resFT(i,1) = mean(F(ceil(interval*length(F)):end));
    resFT(i,1) = F(end);
    resFT(i,2) = Tth;
    
    clear result;
end

if sort_1f_0t
    [v,index1]=sort(resFT(:,2));
    resFT2(:,1)=resFT(index1,1);
    resFT2(:,2)=resFT(index1,2);
    [v,index2]=sort(resFT2(:,1));
else    
    [v,index1]=sort(resFT(:,1));
    resFT2(:,1)=resFT(index1,1);
    resFT2(:,2)=resFT(index1,2);
    [v,index2]=sort(resFT2(:,2),'descend');
end

for i=1:size(files,1)
    disp(name{index1(index2(i))});
    if sort_1f_0t
        disp(['Fitness=' num2str(resFT2(index2(i),1)) '; T_th=' int2str(resFT2(index2(i),2))]);
    else
        disp(['T_th=' int2str(resFT2(index2(i),2)) '; Fitness=' num2str(resFT2(index2(i),1))]);
    end
    disp(' ');
end    
       
%clear resFT; 

    %[vT,indexT]=sort(t,'ascend');
%     for i=1:size(files,1)
%         resultsSummaryF{i}=results1{indexF(i)};
%         resultsSummaryT{i}=results1{indexT(i)};
%         %disp(resultsSummary{i}.name);
        %disp(['Fitness=' num2str(resultsSummary{i}.f) '; T_th=' int2str(resultsSummary{i}.Tth)]);
        %disp(' ');
    %end


% if sort_1f_0t
%     [v,index]=sort(f);
%     for i=1:size(files,1)
%         resultsSummary{i}=results1{index(i)};
%         disp(resultsSummary{i}.name);
%         disp(['Fitness=' num2str(resultsSummary{i}.f) '; T_th=' int2str(resultsSummary{i}.Tth)]);
%         disp(' ');
%     end
% else
%     [v,index]=sort(length(F)-t);
%     for i=1:size(files,1)
%         resultsSummary{i}=results1{index(i)};
%         disp(resultsSummary{i}.name);
%         disp(['T_th=' int2str(resultsSummary{i}.Tth) '; Fitness=' num2str(resultsSummary{i}.f) ]);
%         disp(' ');
%     end
% end

     
