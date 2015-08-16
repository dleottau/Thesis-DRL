function [ actions ] = BuildActionList(cfg)
%BuildActionList

%actions for the mountain car problem
%actions = [-1.0 ; 0.0 ; 1.0];

actions = [0 0; -1 0 ; 1 0; 0 -1; 0 1];

%Neutral, West, East, South, North