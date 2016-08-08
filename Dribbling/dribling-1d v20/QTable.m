function [ Q ] = BuildQTable( nstates,nactions,init )
%BuildQTable do exactly this
%Q: the returned initialized QTable

Q = ones(nstates,nactions);
Q = -init*Q;
%Q = zeros(nstates,nactions)-1; % a variant
%Q = zeros(nstates,nactions)+1; % another variant
%Q = rand(nstates,nactions)-0.5; % a variant