function [ Q ] = BuildQTable( nstates,nactions, Qinit )
%BuildQTable do exactly this
%Q: the returned initialized QTable

Q = Qinit.*ones(nstates,nactions);
%Q = zeros(nstates,nactions);
%Q = zeros(nstates,nactions)-inf; % a variant
%Q = zeros(nstates,nactions)+10; % another variant
%Q = -100*rand(nstates,nactions); % a variant
%Q = random('Normal',0,10,nstates,nactions); % a normal distribution variant