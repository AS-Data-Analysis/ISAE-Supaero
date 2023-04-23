% Variables to be initialized prior to execute be_counter.slx
clear all
clc
close all

Ts = 0.25;

% initial conditions
x0 = [0;0];

% simulation horizon
T = 20;
J = 30;

% rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;

% model configuration parameters
MaxStep = .005;
RelTol = 1e-8;

%sim('Sampling_Device')