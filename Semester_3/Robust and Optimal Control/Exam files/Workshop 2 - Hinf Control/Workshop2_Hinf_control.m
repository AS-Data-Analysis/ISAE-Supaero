clear all
clc
close all

num = 1;
den = [1 0 -1];

num1 = [1 1];
den1 = [1 0.001]; % There should not be a pole on the imaginary axis cause it's required by hinfsyn

num2 = [1 3];
den2 = [1 300];   % We add a fast pole to regularize without changing the bound much. Now, the output becomes constant instead of infinity at high frequencies.

% u and y should be the last input and output ports respectively.

[A,B,C,D] = linmod('Block_Diagram');
P = ss(A,B,C,D);

nmeas = 1; % 1 measurement (the feedback)
ncont = 1; % 1 control input
[K,CL,gamma] = hinfsyn(P,nmeas,ncont) % number of states will be the same as the states in the weighted standard form

% This function gives the optimal solution with the lowest gamma.
% Since gamma > 1, it means atleast 1 of the specifications isn't satisfied
% We have a 4th order controller which is not ideal.

% Which requirement is not satisfied?

norm(CL(1,1),'inf')
norm(CL(2,1),'inf')
% Neither. The norms are less than gamma but gamma is less than 1. To
% satisfy the specifications by changing the Ws to relax the constraints.

% Hinfstruct
% We accept that the problem is not convex. So, we might not have the
% optimum solution but we can use a controller of any order.

% Can we keep the same performance level with a simpler controller

K0=ltiblock.gain('K0',1,1)
% We start with a static controller (1 measurement, 1 control input) when we don't have an idea of the order. Then, we increase the order slowly

% Algorithm is first run with a deterministic initialization, then 3 more
% random starts. So, total 4 runs.
opt=hinfstructOptions('randomstart',3)
[Kf,gopt]=hinfstruct(P,K0,opt)





