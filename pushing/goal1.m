function [ goal, bi ] = goal1( line1,line2 )
% line1=[500 0; 1000 0];line2=[601 501 ;600 -500];
% figure
% h = plot(line1(:,1),line1(:,2));
% hold on
% h(2) = plot(line2(:,1),line2(:,2));
% set(h,'linewidth',2)
% axis([0 1 -1 2])

goal=false;
bi=line2(1,:);
y=0; % (line1(1,2)-line1(2,1))/2;
x = (line2(1,1)-line2(2,1))*(y-line2(2,2))/(line2(1,2)-line2(2,2)) + line2(2,1);

if line2(1,2) < line1(1,2) && (x>line1(2,1) && x<line1(1,1))
    goal=true;
    bi = [x,y];
end
    
%if line2(1,2)





%line2 = line2-[line1(1,:);line1(1,:)];
%line1 = line1-[line1(1,:);line1(1,:)];
% if line2(1,2)<0 || line2(2,2)<0
%     bi(1) = -line2(1,2)*(line2(2,1) - line2(1,1))/(line2(2,2) - line2(1,2)) + line2(1,1);
%     bi(2) = 0;
%     if bi(1)>line1(1,1) && bi(1)<line1(2,1)
%         goal=true;
%     end
%     bi=bi+mn;
% end


% 
% slope = @(line) (line(2,2) - line(1,2))/(line(2,1) - line(1,1));
% intercept = @(line,m) line(1,2) - m*line(1,1);
% 
% m1 = slope(line1)
% m2 = slope(line2)
% b1 = intercept(line1,m1)
% b2 = intercept(line2,m2)
% 
% 
% lineEq = @(m,b, myline) m * myline(:,1) + b;
% yEst2 = lineEq(m1, b1, line2);
% % plot(line2(:,1),yEst2,'om');
% 
% enderr = @(ends,line) ends - line(:,2);
% errs1 = enderr(yEst2,line2);
% 
% yEst1 = lineEq(m2, b2, line1);
% % plot(line1(:,1),yEst1,'or');
% errs2 = enderr(yEst1,line1);
% 
% goal =  sum(sign(errs1))==0 && sum(sign(errs2))==0;
% bi=line1(2,:);
% if goal
%     bi=[(b2-b1)/(m1-m2); (m1*b2-m2*b1)/(m1-m2)]
% end
% 
% end

% 
% function b = intercept(line,m) 
%     if isinf(m)
%         b=line(1,1);    
%     else
%         b=line(1,2) - m*line(1,1);
%     end
% end

