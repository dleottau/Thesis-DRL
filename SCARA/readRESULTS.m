clear all
clc
clf
close all

th=1;
m=1;
interval=0.9;

folder='finalTests/';
files = dir(fullfile([folder '*.mat']));

f=[];
for i=1:size(files,1)
    result=importdata([folder files(i).name]);
    results1{i}.name=files(i).name;
    %results1{i}.f=result.f;
    results1{i}.f = mean(result.cumSteps_mean(ceil(interval*length(result.cumSteps_mean)):end))*4;
    %f(i)=result.f;
    f(i)=results1{i}.f;
    clear result;
end
[v,index]=sort(f);
for i=1:size(files,1)
    resultsSummary{i}=results1{index(i)};
    disp(['f=' num2str(resultsSummary{i}.f) ' ' resultsSummary{i}.name]);
end
clear results1

%     
