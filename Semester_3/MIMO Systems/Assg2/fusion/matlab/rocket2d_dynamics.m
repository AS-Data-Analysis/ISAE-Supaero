function x_dot = rocket2d_dynamics(x,u,rocket)
%ROCKET2D_DYNAMICS 
% All values are in S.I. units!!
%   x = [ pn pd vn vd the ome ]
%   u = [ del ]

%% rocket params
m = rocket.mass; % mass [in S.I. units]
J = rocket.J; % moment of inertia [in S.I. units]
h_cg = rocket.h_cg; % center of gravity height wrt floor [in S.I. units]
g = 10; % gravity
T = rocket.T; % assuming constant thrust here in Newtons!

%% init variables
x_dot = zeros(6,1);
the = x(5);
del = u(1);

%% derivative of position is velocity
x_dot(1:2) = x(3:4);

%% derivative of velocity
x_dot(3:4) = -[ sin(del+the); cos(del+the)]*T/m + [0;1]*g;

%% derivative of angle
x_dot(5) = x(6);

%% derivative of angular velocity
M = -T*h_cg*sin(del);
x_dot(6) = 1/J*M;

end
