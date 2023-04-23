%% Simulation Start Up for drones in the ISAE-laboratory
%%
%   Authors:F.defay & C.Chauffaut 
%   Date:   20/03/2017
%   Version:3.0
%-----------------------------------------% 

 clear  all;
 clc;

init_matlab=exist('init_matlab','var')

%% Execute only once
if (init_matlab==0)
    %% Clean the workspace and set the path
    %-----------------------------------------%
    clc;clear all;close all
    warning('off','all');
    
    %% init path
    addpath(fullfile('Setup'));
    init_path;
    init_matlab = 1;
end

%% Specifications of the model of UAV
%-----------------------------------------% 
% Vehicle specification (protection of the parrot (true) or not (false))
drone.protection=false;

% Type of UAV
modele_mikrokopter;

% Inner loop attitude gains (for PX4 autopilot) 
px4_inner_loop_gain; 

% MRAC gain
MRAC;

%%    Initial state and values           %%
%-----------------------------------------% 

batt.initial_voltage = 16;

init.psi_north = 2.8;  %ifference between inertial frame and local (optitrack frame)

init_state.eul_0=[0;0;init.psi_north];
init_state.Vuvw0 = [0 0 0];                           % initial velocity (Rd)    [u v w]
init_state.Pterre0 = [0 0 0];                         % Initial position (Ro)    [x y z]
init_state.pqr0 = [0 0 0];                            % angular velocity         [p q r]
init_state.Angles0 = [0 0 0];                         % Initial attitude      [roll pitch yaw]


%% Delay ans sample time 
%-----------------------------------------% 
% sample time of Simulink position control
Te= 2e-2;
% sample time of px4 control
Ts_px4= 5e-3;
% sample time of gumstix control
% Ts_gumstix= 2e-2;
% time delay for sending control to px4 board from simulink
dT_udp_px4 = 0.02; 
% time delay from px4 to simulink
dT_px4_udp = 0.02;
% time delay from gumstix to simulink
dT_udp = 0.02;

%% Mission parameters
%-----------------------------------------% 
missiontype  = '200g'
noise = 'off'
tdrop  = 30;
%-----------------------------------------%

Mass_drop;

