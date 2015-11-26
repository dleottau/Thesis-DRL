function [ Q ] = QTable( S,A,conf )
%BuildQTable do exactly this
%Q: the returned initialized QTable

Q = conf.Q_INIT * ones(S,A);
%Q = zeros(nstates,nactions)-1; % a variant
%Q = zeros(nstates,nactions)+1; % another variant
%Q = rand(nstates,nactions)-0.5; % a variant