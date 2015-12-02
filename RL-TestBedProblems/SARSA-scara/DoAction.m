function [ xt , ret_state ] = DoAction(state, action )
%DoAction: executes the action (a) into the SCARA Robot
% a: is the force to be applied to the car
% x: is the vector containning the position and speed of the car
% xp: is the vector containing the new position and velocity of the car



%bounds for angles
maxangle =  pi;
minangle = -pi;

top    =  0;
bottom =  2;



ret_state = state + action;

 x =[ret_state(1) ret_state(2) ret_state(3)];
 
 ind    = find(x>maxangle);
 x(ind) = maxangle;
 
 ind    = find(x<minangle);
 x(ind) = minangle;
 
 ret_state(1) = x(1);
 ret_state(2) = x(2);
 ret_state(3) = x(3);

if (ret_state(4)>bottom)
    ret_state(4)=bottom;
end


if (ret_state(4)<top)
    ret_state(4)=top;
end

pos = scarapos(ret_state(1),ret_state(2),ret_state(3),ret_state(4));
xt  = pos(5,:);







