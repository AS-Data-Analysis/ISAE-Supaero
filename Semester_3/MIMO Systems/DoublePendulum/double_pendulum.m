function xdot = double_pendulum(x,u)

theta1 = x(1);
theta2 = x(2);
theta1_dot = x(3);
theta2_dot = x(4);

M = zeros(2,2);
M(1,1) = 3+2*cos(theta2);
M(1,2) = 1+cos(theta2);
M(2,1) = 1+cos(theta2);
M(2,2) = 1;

xdot = zeros(4,1);
xdot(1,1) = theta1_dot;
xdot(2,1) = theta2_dot;

f = zeros(2,1);
f(1,1) = -(2*theta1_dot+theta2_dot)*theta2_dot*sin(theta2)+20*sin(theta1)+10*sin(theta1+theta2); 
f(2,1) = theta1_dot^2*sin(theta2) + 10*sin(theta1+theta2);

xdot(3:4,1) = M\(u-f);
