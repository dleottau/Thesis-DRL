function [x,fval]=hillDLF(fitnessfun,x0,options,varargin)
%Syntax: [x,fval,gfx,output]=hill(fitnessfun,x0,options,varargin)
%________________________________________________________________
%
% A hill climbing algorithm for finding the minimum of a function
% 'fitnessfun' in the real space.
%
% x is the scalar/vector of the functon minimum
% fval is the function minimum
% gfx contains the minimization solution each iteration (columns 2:end)
%  and the corresponding function evaluation (column 1)
% output structure contains the following information
%   reason : is the reason for stopping
%   MaxIter: the maximum climbs before stopping
%   time   : the total time before stopping
% fitnessfun is the function to be minimized
% x0 is the initial point
% options are specified in the file "hilloptions.m"
%
% Example:
%    function e = parabola(x,y)
%    e = sum(x.^2)+y;
%
%    options = hilloptions('space',[-ones(8,1) ones(8,1)]);
%    [x,fval,gfx,output]=hill(@parabola,rand(8,1),options,2.3); % y = 2.3
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110- Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% Dec 8, 2004.


% Make x0 a column vector
x0=x0(:);

if nargin<3 | isempty(options)==1
    options=hilloptions;
end

if size(options.space,1)==1
    for i=2:length(x0)
        options.space(i,:)=options.space(1,:);
    end
elseif size(options.space,1)~=length(x0)
    error('The rows of options.space are not equal to the number of dimensions.');
end

space = options.space;
MaxIter = options.MaxIter;
prec = options.prec;
line = options.line;
Display = options.Display;
TimeLimit = options.TimeLimit;
Goal = options.Goal;
step =  options.step;
peaks = options.peaks;
oneDimPerTry = options.oneDimPerTry;
%peakStep = options.peakStep;


% Check if x0 is within the boundaries
if any(x0<space(:,1)) | any(x0>space(:,2))
    error('x0 is outside the space boundaries.');
end

if Display>0 & strcmp(Display,'Final')==0
    fprintf('                              \n');
    fprintf('   Iteration           f(x)   \n');
    fprintf('   __________      ___________\n');
    fprintf('                              \n');
end

tic;
Time = 0;
output.reason = 'Optimization terminated: maximum number of climbs reached.';

% Define the precision of each parameter
%h=10^(-prec)*(space(:,2)-space(:,1));

y0_initial=feval(fitnessfun,x0,varargin{:});
[ states, V ] = BuildStateList(space,step);
s=DiscretizeState(x0,states);
V(s)=y0_initial;
s0=s;
ymin=-inf;
fval=inf;
iter=1;

while sum(isinf(V))>0.1*size(V,1) || iter<MaxIter
    % Try a step on each dimension...
    for j=1:length(x0)
        ymin=-inf;
        while V(s0)>ymin
            s0=s;
            x0=states(s0,:)';
            x=x0;
            
            % ... towards -inf
            for p=1:peaks
                x(j)=max(space(j,1),x0(j)-p*step(j));
                s=DiscretizeState(x,states);
                x=states(s,:)';
                if V(s)==inf
                    V(s)=feval(fitnessfun,x,varargin{:}); %
                end
            end
            
            % ... towards inf
            for p=1:peaks
                x(j)=min(x0(j)+p*step(j),space(j,2));
                s=DiscretizeState(x,states);
                x=states(s,:)';
                if V(s)==inf
                    V(s)=feval(fitnessfun,x,varargin{:});
                end
            end
            
            [ymin s]=min(V);
            if ~oneDimPerTry % If option to explore every dimension untill find the best is not enabled
                % It breaks while loop
                s0=s;
            end
        end
    end
    if fval<=ymin
        break;
    end
    fval=ymin;
    
end
%end

fval=ymin;
x=states(s,:)';

end



% while sum(isinf(V))>0.1*size(V,1)
%     % Try a step on each dimension...
%     for j=1:length(x0)
%         ymin=-inf;
%         while V(s0)>ymin
%             s0=s;
%             x0=states(s0,:)';
%             x=x0;
%
%             % ... towards -inf
%             for p=1:peaks
%                 x(j)=max(space(j,1),x0(j)-p*step(j));
%                 s=DiscretizeState(x,states);
%                 x=states(s,:)';
%                 if V(s)==inf
%                     V(s)=feval(fitnessfun,x,varargin{:}); %
%                 end
%             end
%
%             % ... towards inf
%             for p=1:peaks
%                 x(j)=min(x0(j)+p*step(j),space(j,2));
%                 s=DiscretizeState(x,states);
%                 x=states(s,:)';
%                 if V(s)==inf
%                     V(s)=feval(fitnessfun,x,varargin{:});
%                 end
%             end
%
%             % Choose the steepest step
%             [ymin s]=min(V);
%         end
%     end
%     if fval<=ymin
%         break;
%     end
%     fval=ymin;
%
% end
% %end
%
% fval=ymin;
% x=states(s,:)';
%
% end


function [ states, V ] = BuildStateList(space,step)
%BuildStateList builds a state list from a state matrix

Ndim=size(step,1);
nstates=1;
for n=1:Ndim
    x{n}=space(n,1):step(n):space(n,2);
    N(n)=length(x{n});
    nstates=nstates*N(n);
end

states=zeros(nstates,Ndim);
vi=ones(1,Ndim);
dim=1;
index=1;
[ states, index, vi ] = forNested(x,N,dim,index,states,vi);
V=inf*ones(nstates,1);
end


function [ states, index, vi ] = forNested(x,N,dim,index,states,vi)

for d=1:N(dim)
    
    if dim==length(N)
        for n=1:length(N)
            states(index,n)=x{n}(vi(n));
        end
        index=index+1;
    else
        [ states, index, vi ] = forNested(x,N,dim+1,index,states,vi);
    end
    vi(dim)=vi(dim)+1;
end
vi(dim)=1;
end

function [ s ] = DiscretizeState( x, statelist  )
%DiscretizeState check which entry in the state list is more close to x and
%return the index of that entry.

%[d  s] = min(dist(statelist,x'));

xr = repmat(x',size(statelist,1),1);
[d  s] = min(edist(statelist,xr));
end

function V=updateV(x,y,states,V)
    s=DiscretizeState(x,states);
    V(s)=y;
end