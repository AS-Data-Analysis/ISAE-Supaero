clear all;clc;
close all;
warning off;

% gearmotor data
Re = 2; Le = 0.002; ke = 0.2; km = 0.2; 
Jm = 0.002; N = 100;

% load data
Jl = 100;
Jt = Jl+N^2*Jm;


%% Question 2.1 - model by transfer function (without load)
Kl= 0;
b = 0; 

num = N*km;
den = [Jt*Le Jt*Re N^2*km*ke 0];

%% Question 2.2 - poles of the model without load

%% Question 2.3 - state space model of the model without load
% state-space model from simulink block diagram (without load)
sys = linmod('open_loop_satellite_noload');
open_loop_satellite0 = ss(sys.a,sys.b,sys.c,sys.d);

%% Question 2.4 - step response of the model without load

%% Question 3.1 -  model by transfer function (with load)
Kl= 1e4;
b = 10; 
% model by transfer function (with load)
num = N*km;
den = [Jt*Le Jt*Re+Le*b N^2*km*ke+Re*b+Le*Kl Re*Kl];
sys = tf(num,den);

%% Question 3.2 - poles of the model with load

%% Question 3.3 - state space model of the model with load

%model by block diagram (with load)
sys1 = linmod('open_loop_satellite_load');
open_loop_satellite = ss(sys1.a,sys1.b,sys1.c,sys1.d)

% state space representation from equations (with load)

%% Question 3.4 - styep response of the model with load

%% Question 3.5 - observability and governability of the model with load

%% Question 3.6 - ubiqueness of the state spae representation (model with load)