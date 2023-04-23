clear all
clc

% Experiment  parameters
%


%% 200g

drone.mtot = 1.36;
mass = 0.2;        % Additive mass
tdrop=20;          % drop time
m=drone.mtot+mass;
th0=0.45;          % Thrust for gravity compensation

% Desired dynamics
omega=2;
epsilon=0.8;