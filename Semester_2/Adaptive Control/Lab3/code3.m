clear all
clc

B = 0.2;
J = 0.02;
Kb = 0.015;
Km = 0.015;
L = 0.5;
R = 2;
%Kf = linspace(0.2,2,10);
Kf = 2;
s = tf('s');
Ref = 60/(s^2+15*s+60);

gamma = 5;