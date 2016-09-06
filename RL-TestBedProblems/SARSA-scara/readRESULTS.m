clear all
clc
clf
close all

th=1;
m=10;

folder='opti/testCALR/';
files = dir(fullfile([folder '*.mat']));

f=[];
for i=1:size(files,1)
    result=importdata([folder files(i).name]);
    results1{i}.name=files(i).name;
    results1{i}.f=result.f;
    f(i)=result.f;
    clear result;
end
[v,index]=sort(f);
for i=1:size(files,1)
    resultsSummary{i}=results1{index(i)};
    disp(['f=' num2str(resultsSummary{i}.f) ' ' resultsSummary{i}.name]);
end
clear results1

%     
