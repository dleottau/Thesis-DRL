clc
clf
clear all
close all
%dbstop in GetBestAction.m at 19;
%dbstop in Episode.m if isnan(sum(sum(RL.Q)))
%dbstop in Episode.m at 53 if isnan(sum(sum(RL.Q)))
dbstop in UpdateSARSA.m at 28% if isnan(sum(sum(Q)))
%dbstop if naninf;


x0 = [];
%x0(1) = 0.8;   % learning rate
%x0(2)  = 0.99;   % discount factor
%x0(2) = 0.95;  %elegib trace decay
x0(1) = 0.7;  % epsilon, probability of a random action selection
x0(2) = 7;  %exploration decay factor
%----------  

options = hilloptions('TimeLimit', 600, 'line',2);
options.step = [0.1;1];
options.space = [[0; 0], [1; 10]];
%options.step = 0.1;
%options.space = [0.01, 0.999];
%options.peaks = 3;
%options.peakStep = 4;


[x,fval,gfx,output]=hillDLF(@optimizationFunction,x0,options);
x
fval




%options = optimset('Display','iter','TolFun',1e-8)
%This statement makes a copy of the options structure called options, changing the value of the TolX option and storing new values in optnew.


%This statement returns an optimization options structure options that contains all the option names and default values relevant to the function fminbnd.

%options = optimset('fminbnd')
%If you only want to see the default values for fminbnd, you can simply type
