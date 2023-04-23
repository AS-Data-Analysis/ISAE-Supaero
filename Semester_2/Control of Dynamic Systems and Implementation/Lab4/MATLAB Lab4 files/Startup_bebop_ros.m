%% Simulation Start Up for drones in the ISAE-laboratory
%%
%   Authors: F.defay & C.Chauffaut 
%   Date:    21/11/2018
%   Version: 4.0
%   Matlab: 2017b
%-----------------------------------------% 

init_matlab=exist('init_matlab','var');

%% Execute only once
if (init_matlab==0)
    %% Clean the workspace and set the path
    %-----------------------------------------%
    clc;clear all;close all
    warning('off','all');
    
    %% init path
    addpath(fullfile('Setup'));
    init_path_bebop_ros;
    init_matlab = 1;
end

%% Specifications of the model of UAV
%-----------------------------------------% 
% Vehicle specification (protection of the parrot (true) or not (false))
drone.protection=false;

% Type of UAV
modele_Bebop;

% Inner loop attitude gains (for PX4 autopilot) 
bebop_gain; 

% Ros Init
setenv('ROS_MASTER_URI','http://10.255.100.224:11311');

assignin('base', 'SIMULATION_MODE', Simulink.Variant('mode_id==0'));
assignin('base', 'EXPERIMENT_MODE', Simulink.Variant('mode_id==1'));
mode_id=0;


% Creat bus structures
load('BUS_simodrone.mat');

%%    Initial state and values            %
%-----------------------------------------% 
batt.initial_voltage =12.5;
% Difference between inertial frame and local (optitrack frame)
init_state.psi_north = 2.5;  

init_state.eul_0=[0;0;init_state.psi_north];
init_state.Vuvw0 = [0 0 0];                           % initial velocity (Rd)    [u v w]
init_state.Pterre0 = [0 0 0];                         % Initial position (Ro)    [x y z]
init_state.pqr0 = [0 0 0];                            % angular velocity         [p q r]
init_state.Angles0 = [0 0 0];                         % Initial attitude      [roll pitch yaw]



%% Delay ans sample time 
%-----------------------------------------% 
% sample time of Simulink position control
Ts_optitrack= 2e-2; %50Hz
% sample time of bebop onboard control
Ts_bebop= 5e-3; %200Hz
% sample time of control
Ts_control= 2e-2; %50Hz
% sample time of video
Ts_video= 3.33e-2;
% sample time of bebop feedback
Ts_bebop_feedback= 2e-1; %5Hz mesures bebop (alt/att/vitesse)
%sample time for display
Te = Ts_optitrack;

%sample time to initialize Ros
Te_topics_empty = 0.1;
%sample time to initialize Ros
Te_robot = 0.2;

%Te_guidance = 0.2;

% time delay for sending control to px4 board from simulink
measure.dT_udp_px4 = 0.02; 
% time delay from px4 to simulink
measure.dT_px4_udp = 0.02;
% time delay from gumstix to simulink
measure.dT_udp = 0.02;

% Edit by the student (Akash Sharma)
run('Control')