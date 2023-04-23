%% Exercise 1

clear all
clc
close all

A = [-3 0 ; 0 -3];
B = [2 ; 2];

K = ctrb(A,B)

%% Exercise 2

clear all
clc
close all

syms theta1 theta2 theta_dot1 theta_dot2 u1 u2

x = [theta1 ; theta2 ; theta_dot1 ; theta_dot2];
u = [u1 ; u2];

x_dot = double_pendulum(x,u);

xtrim = [pi ; 0 ; 0 ; 0];
utrim = [0 ; 0];

A = jacobian(x_dot,x);
B = jacobian(x_dot,u);

Atrim = double(subs(A,[x ; u],[xtrim ; utrim]));
Btrim = double(subs(B,[x ; u],[xtrim ; utrim]));

Ctrim = eye(4);
Dtrim = zeros(4,2);

sys = ss(Atrim,Btrim,Ctrim,Dtrim);

rank(Btrim);

eig(Atrim);

rank(obsv(Atrim,Ctrim));

rank(ctrb(Atrim,Btrim));

sys_broken = ss(Atrim,Btrim(:,2),Ctrim,Dtrim(:,2));

rank(ctrb(Atrim,Btrim(:,2)));

rank(B(:,2));

%% Exercise 3

clear all
clc
close all

A = 1e-5*[-0.1 -1 ; 2 -0.1];

B = [1 3 ; 2 -1];

C = eye(2);

D = zeros(2,2);

s = tf('s');
G = C*inv(s*eye(2) - A)*B + D

sigma(G)
