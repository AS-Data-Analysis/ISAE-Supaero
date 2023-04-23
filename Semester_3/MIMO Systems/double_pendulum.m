function xdot = double_pendulum(x,u)

theta1 = x(1);
theta2 = x(2);
theta1_dot = x(3);
theta2_dot = x(4);

M = zeros(2,2);
M1 = 3+2*cos(theta2);
M2 = 1+cos(theta2);
M3 = 1+cos(theta2);
M4 = 1;

M = [M1 M2 ; M3 M4];

xdot1 = theta1_dot;
xdot2 = theta2_dot;

f1 = -(2*theta1_dot+theta2_dot)*theta2_dot*sin(theta2)+20*sin(theta1)+10*sin(theta1+theta2); 
f2 = theta1_dot^2*sin(theta2) + 10*sin(theta1+theta2);

f = [f1 ; f2];
xdot3 = M\(u-f);

xdot = [xdot1 ; xdot2 ; xdot3];