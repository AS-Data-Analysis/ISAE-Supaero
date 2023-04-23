%% Exercise 1 : Linearization

clear all
clc
close all

% Creating a structure for the system's physical properties
drone = struct('m_d',1,'m_c',1,'l',1,'l_d',1,'J',1,'C_D',0.01,'g',10);

syms x u w pn pd T1 T2 vn vd theta thetad gamma gammad wn wd

x = [pn ; pd ; vn ; vd ; theta ; thetad ; gamma ; gammad];
u = [T1 ; T2];
w = [wn ; wd];
x_dot = chardonnay_dynamics(x,u,w,drone);
x_dot = x_dot(3:8);
x = x(3:8);

xt = zeros(6,1);
ut = 10*ones(2,1);
wt = zeros(2,1);

A = jacobian(x_dot,x);
B = jacobian(x_dot,u);
E = jacobian(x_dot,w);

At = subs(A,[x ; u ; w],[xt ; ut ; wt]);
Bt = subs(B,[x ; u ; w],[xt ; ut ; wt]);
Et = subs(E,[x ; u ; w],[xt ; ut ; wt]);

delta_x_dot = At*(x - xt) + Bt*(u - ut) + Et*(w - wt);

%% Exercise 2 : Phase Planes and Linearization

clear all
clc
close all

% Creating a structure of the simple pendulum
pendulum = struct('g',10,'l',1,'b',1,'m',1);

% Phase Portrait

theta = linspace(-4*pi,4*pi,60);
thetad = linspace(-4*pi,4*pi,60);

[X,Y] = meshgrid(theta,thetad);

U = zeros(size(X));
V = zeros(size(Y));

torque_input = 0;
for i = 1:numel(X)
        xprime = pendulum_dynamics([X(i) ; Y(i)],torque_input,pendulum);
        U(i) = xprime(1);
        V(i) = xprime(2);
end

subplot(2,1,1)
quiver(X,Y,U,V,1)


% Model Linearization and Phase Portrait

syms x u theta thetad

x = [theta ; thetad];

xt = [0 ; 0];
ut = 0;

x_dot = pendulum_dynamics(x,u,pendulum);

A = jacobian(x_dot,x);
B = jacobian(x_dot,u);

At = subs(A,[x ; u],[xt ; ut]);
Bt = subs(B,[x ; u],[xt ; ut]);

delta_x_dot = At*(x - xt) + Bt*(u - ut);

for i = 1:numel(X)
    xprime = subs(delta_x_dot,[x ; u],[[X(i) ; Y(i)] ; 0]);
    U(i) = xprime(1);
    V(i) = xprime(2);
end

subplot(2,1,2)
quiver(X,Y,U,V,1)


%% Exercise 3 : Phase Portraits and Regions of Attractions

clear all
clc
close all

model = struct('alpha',1,'kp',100,'kd',10000);

x = linspace(-5,5,50);
xd = linspace(-5,5,50);

[X,Y] = meshgrid(x,xd);

U = zeros(size(X));
V = zeros(size(Y));


for i = 1:numel(X)
        xprime = NL_system([X(i) ; Y(i)],model);
        U(i) = xprime(1);
        V(i) = xprime(2);
end

quiver(X,Y,U,V,s)

%{
% Linearized version

syms X x xd

X = [x ; xd];

Xt = [0 ; 0];

X_dot = NL_system(X,params);

[Xq,Yq] = meshgrid(linspace(-5,5,N),linspace(-5,5,N));

U = zeros(size(Xq));
V = zeros(size(Yq));

A = jacobian(X_dot,X);

At = subs(A,X,Xt);

delta_X_dot = At*(X - Xt);

for i = 1:numel(Xq)
    xprime = subs(delta_X_dot,[x ; xd],[Xq(i) ; Yq(i)]);
    U(i) = xprime(1);
    V(i) = xprime(2);
end

subplot(2,1,2)
quiver(Xq,Yq,U,V,scale)
%}

%% Functions

function x_dot = pendulum_dynamics(x,u,pendulum)
% x = [theta ; thetad];

g = pendulum.g;
l = pendulum.l;
b = pendulum.b;
m = pendulum.b;

x_dot = [x(2) ; (-g/l)*sin(x(1)) - (b/(m*l^2))*x(2) + 1/(m*l^2)*u];

end


function X_dot = NL_system(X,params)
% X = [x ; xd]

alpha = params.alpha;
kp = params.kp;
kd = params.kd;

X_dot = [X(2) ; (3*alpha/(1+kd))*X(1)^2 - kp/(1+kd)];

end