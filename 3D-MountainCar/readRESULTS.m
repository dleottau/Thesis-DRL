clear all
clc
clf
close all

th=-300;
m=1;
interval=0.9;

folder='experimentsFull/fig3/';
files = dir(fullfile([folder '*.mat']));

j=1;
for i=1:size(files,1)
    result=importdata([folder files(i).name]);
    rth = find(result.mean_cumReward>th);
    if ~isempty(rth) && length(rth)>=m
        time_th=rth(m);
    else time_th=inf;
    end
    results1{i}.name=files(i).name;
    results1{i}.time_th=time_th;
    %results1{i}.meanRew=result.performance(1,1);
    results1{i}.meanRew = mean(result.mean_cumReward(ceil(interval*length(result.mean_cumReward)):end));
    itae(i)=-result.performance(1,2);
    results1{i}.meanITAE=itae(i);
    clear result rth;
end
[v,index]=sort(itae);
for i=1:size(files,1)
    resultsSummary{i}=results1{index(i)};
    disp(resultsSummary{i}.name);
    disp(['t_th=' int2str(resultsSummary{i}.time_th) '; mRew=' num2str(resultsSummary{i}.meanRew) '; mITAE=' num2str(resultsSummary{i}.meanITAE) ]);
    disp(' ');

end
clear results1

%     
