%% State-Space Representation

clear all
clc
close all

w=1;
A = [0 0 1 0
     0 0 0 1
     3*w^2 0 0 -2*w
     0 0 2*w 0];
B = [0 0
     0 0
     1 0
     0 1];

C = eye(4);
D = zeros(4);


% Using radial thrust
rank(ctrb(A,B(:,1)))

% Using tangential thrust
rank(ctrb(A,B(:,2)))

% Therefore, only tangential thrust can be used if 1 control input is used


%% 1 Control Input

clear all
clc
close all

N = 1000;
T_orb = 5400;

w = 2*pi/T_orb;
T = T_orb/4;

% State Space Representation of the System

A = [0 0 1 0
     0 0 0 1
     3*w^2 0 0 -2*w
     0 0 2*w 0];
B = [0 0
     0 0
     1 0
     0 1];

B = B(:,2);
C = eye(4);
D = 0;

Q = zeros(4);
R = 1;

X0 = [0 ; 10^3 ; 0 ; 0];
%X0 = [0 ; -10^3 ; 0 ; 0];
%X0 = [10^3 ; 0 ; 0 ; 0];
%X0 = [-10^3 ; 0 ; 0 ; 0];

trajt = [];
trajX = [];
trajU = [];

P = [];
for i=1:N+1
    t = T*(i-1)/N;
    [K_t,P_t,phi_t]=twopbvp(T,t,A,B,Q,R);
    P = [P P_t];
    trajt(:,i) = t;
    trajX(:,i) = phi_t*X0;
    trajU(:,i) = -K_t*trajX(:,i);
end

P0 = P(1:4,1:4);
Jcap = 0.5*X0'*P0*X0;

plotresults(trajt, trajX, trajU)


%% 2 Control Inputs

clear all
clc
close all

N = 1000;
T_orb = 5400;

w = 2*pi/T_orb;
T = T_orb/4;

% State Space Representation of the System

A = [0 0 1 0
     0 0 0 1
     3*w^2 0 0 -2*w
     0 0 2*w 0];
B = [0 0
     0 0
     1 0
     0 1];

C = eye(4);
D= zeros(4);

Q = zeros(4);
R = eye(2);

X0 = [0 ; 10^3 ; 0 ; 0];
%X0 = [0 ; -10^3 ; 0 ; 0];
%X0 = [10^3 ; 0 ; 0 ; 0];
%X0 = [-10^3 ; 0 ; 0 ; 0];

trajt = [];
trajX = [];
trajU = [];

P = [];
for i=1:N+1
    t = T*(i-1)/N;
    [K_t,P_t,phi_t]=twopbvp(T,t,A,B,Q,R);
    P = [P P_t];
    trajt(:,i) = t;
    trajX(:,i) = phi_t*X0;
    trajU(:,i) = -K_t*trajX(:,i);
end

P0 = P(1:4,1:4);
Jcap = 0.5*X0'*P0*X0;

plotresults(trajt, trajX, trajU)