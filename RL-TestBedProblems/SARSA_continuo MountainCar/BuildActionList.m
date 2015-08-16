function [ actions ] = BuildActionList(cfg)
%BuildActionList

%actions for the mountain car problem
%actions = [-1.0 ; 0.0 ; 1.0];

if cfg.DRL
     actions = [-1 0 1]';
else
    actions = [-1 -1; -1 0; -1 1; 0 -1; 0 0; 0 1; 1 -1; 1 0; 1 1];
    %actions = [0 0; -1 0 ; 1 0; 0 -1; 0 1];
    %Neutral, West, East, South, North

end