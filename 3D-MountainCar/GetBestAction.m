function [ a ] = GetBestAction( Q, FV)
%GetBestAction return the best action for state (s)
%Q: the Qtable
%s: the current state
% Q has structure  Q(states,actions)

Qvalue=zeros(1,size(Q,2));
for i=1:size(Q,2);
    %[value(1,i) b rul(:,i)] = efbd(x, Q(:,i), cores);
    Qvalue(1,i) = getQvalue(Q(:,i), FV);
end

[v a] = max(Qvalue(1,:));
[qw] = find(Qvalue(1,:)==v);

% if isempty(qw)
%     qw
%     v
%     a
% end

a = qw( randi(size(qw,2)));

