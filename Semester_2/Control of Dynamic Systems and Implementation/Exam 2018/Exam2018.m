clear all
close all
clc

% Plant
num = [1];
den = [1 0 0];
F = tf(num,den);

% Requirements
omega = 3;
sigma = 0.7;

% Pole Placement
p = roots([1 2*sigma*omega omega^2]);
[A,B,C,D] = tf2ss(num,den);
% Since both y and yd are supposed to be measured, C = [0 1 ; 1 0] in an
% observer if we create it

K = place(A,B,p);
K1 = K(1);
K2 = K(2);
N = K2;

% ----------------------------------------------------------------------------
% Considering the Actuator Dynamic

% We see the instability and oscillations.
% On the rlocus now, we see that the 2 poles go unstable with all values of
% gain, so the system is very unstable and at gain=0, it is barely stable.
% This system needs to be stabilize the third state as well.
A_actuator = 1;
tau = 0.4;
Fc = tf([1],[0.4 1 0 0]);
%rlocus(Fc)

% To design a state feedback controller for a 3rd order system, we will
% approximate the required performance using one for a 2nd order system
% with a fast pole.

fast_pole = [-15];
poles = [p' fast_pole]';
Ac = [-2.5 0 0 ; 1 0 0 ; 0 1 0];
Bc = [2.5 ; 0 ; 0];
Cc = [0 0 1];
Dc = 0;

Kc = place(Ac,Bc,poles);
K1c = Kc(1);
K2c = Kc(2);
K3c = Kc(3);
Nc = K3c;

% ----------------------------------------------------------------------------
% Creating an Observer

% The poles of the observer should be fast enough so as to not affect the
% dynamic of the system

% C = [1 0 0 ; 0 1 0] for an observer
random_fast_poles = [-15 -10 -20];
L = place(Ac',Cc',random_fast_poles)';

% ----------------------------------------------------------------------------
% Tuning a PD controller
Kp = 0.01859;
Kd = 1.069;