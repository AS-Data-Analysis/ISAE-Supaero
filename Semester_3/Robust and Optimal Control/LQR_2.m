%% Weighted Control

clear all
clc
close all

A = [-1.417 1 ; 2.86 -1.183];
B = [0 ; -3.157];

N = [0 1];
Q = N'*N;

% Check Kalmann Equality
R = 1000
[P,K,eigCL] = icare(A,B,Q,R)

betas = poly(eigCL) % beta(s)
betams = poly(-eigCL) % beta(-s)

conv(betas,betams) % beta(s)*beta(-s)

[numG,denG] = ss2tf(A,B,N,0) % G(s) = N*(sI-a)^(-1)*B
[numGms,denGms] = ss2tf(-A,-B,N,0)
conv(denG,denGms) + 1/R*conv(numG,numGms) % D(s)*D(-s) + 1/R*N(s)*N(-s)

%% Cheap Control

clear all
clc
close all

A = [-1.417 1 ; 2.86 -1.183];
B = [0 ; -3.157];

N = [0 1];
Q = N'*N;

R = 0.01
[P,K,eigCL] = icare(A,B,Q,R)

[numG,denG] = ss2tf(A,B,N,0);
G = tf(numG,denG);
zero(G)
sqrt(numG(2)^2/R)

%% Step Response

clear all
clc
close all

A = [-1.417 1 ; 2.86 -1.183];
B = [0 ; -3.157];

N = [0 1];
Q = N'*N;

R = 0.01
[P,K,eigCL] = icare(A,B,Q,R)

F = 1
C = [0 1]
CL = ss(A-B*K,B*F,C,0)
eig(A-B*K)
step(CL)
grid on

% With a proper value of the pre-filter gain

F = -inv(C*inv(A-B*K)*B)
CL = ss(A-B*K,B*F,C,0)
step(CL)
grid on

%% Mirror Property

clear all
clc
close all

A = [-1.417 1 ; 2.86 -1.183];
B = [0 ; -3.157];

N = [0 1];
Q = N'*N;

R = 0.01

alpha = 2
[P,K,eigCL] = icare(A+alpha*eye(2),B,zeros(2),R)
Q = 2*alpha*P
eig(A-B*K)
eig(A+alpha*eye(2))

%% Tracking

clear all
clc
close all

A = [-1.417 1 ; 2.86 -1.183];
B = [0 ; -3.157];
C = [0 1];

R = 0.01

T = 1
Aa = [A zeros(2,1) ; -T*C  0]
Ba = [B ; 0]
Na = [C 1] % obsv(Aa,Na) should be full rank
rank(ctrb(Aa,Ba)) % should be full rank

Qa = Na'*Na
[P,K,eigCL] = icare(Aa,Ba,Qa,R)

CL = ss(Aa-Ba*K,[zeros(2,1) ; T],[C 0],0)
step(CL)
grid on