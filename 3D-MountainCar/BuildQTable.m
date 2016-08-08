function [ Q ] = BuildQTable( nstates,nactions,q_init )
%BuildQTable do exactly this
%Q: the returned initialized QTable

Q = q_init*ones(nstates,nactions);
