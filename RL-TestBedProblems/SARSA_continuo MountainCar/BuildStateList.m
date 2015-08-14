function [ cores, nstates ] = BuildStateList
%function [ cores ] = BuildStateList
%BuildStateList builds a state list from a state matrix

% state discretization for the mountain car problem
xdiv  = (0.55-(-1.5))   / 10.0;
xpdiv = (0.07-(-0.07)) / 5.0;

x = -1.5:xdiv:0.5;
xp= -0.07:xpdiv:0.07;

x_std = x*0 + xdiv;
xp_std = xp*0 + xpdiv;

cores.mean.x = x;
cores.mean.xp = xp;
cores.std.x = x_std;
cores.std.xp = xp_std;

N=size(x,2);
M=size(xp,2);
nstates=N*M;


% states=[];
% index=1;
% for i=1:N    
%     for j=1:M
%         states(index,1)=x(i);
%         states(index,2)=xp(j);
%         dev(index,1)=xdiv;
%         dev(index,2)=xpdiv;
%         index=index+1;
%     end
% end
