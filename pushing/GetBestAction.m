function [ a ] = GetBestAction( Q, FV)
%GetBestAction return the best action for state (s)
%Q: the Qtable
%s: the current state
% Q has structure  Q(states,actions)


Qvalue=zeros(1,size(Q,2));
for a=1:size(Q,2);
    Qvalue(1,a) = getQvalue(Q(:,a), FV);
end

[v a] = max(Qvalue(1,:));
[qw] = find(Qvalue(1,:)==v);
a = qw( randi(size(qw,2)));


