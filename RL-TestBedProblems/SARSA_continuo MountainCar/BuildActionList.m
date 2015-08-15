function [ actions ] = BuildActionList(cfg)
%BuildActionList

%actions for the mountain car problem
actions = [-cfg.actionStep ; 0.0 ; cfg.actionStep];

