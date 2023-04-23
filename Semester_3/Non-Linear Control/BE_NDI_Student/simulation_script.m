%**************************************************************************
%**************************************************************************
% Feedback linearization applied to helicopter control 
%**************************************************************************
%**************************************************************************

%==========================================================================
% Data
%==========================================================================

% Helicopter dynamics
m = 10;
J = 0.2;
f = 0.1;
g = 9.81;

% Actuators
tau = 0.1;
Lmin = 0; Lmax = 200;  
Tmin = -0.035; Tmax = 0.035; 



%%
%==========================================================================
% Open loop simulation
%==========================================================================

% Simulation
Tsim = 30;
DTsim = 0.01;

% Input demand on the Lift
d1_step_start = 5;
d1_step_stop  = Tsim+1;
d1_step_initial_value = m*g;
d1_step_final_value = m*g*1.1;

% Input demand on the Torque
d2_step_start = 10;
d2_step_stop  = Tsim+1;
d2_step_initial_value = 0;
d2_step_final_value = 0.01;

% Simulation
sim('simulation_model_1');

% Plots
figure;
subplot(5,1,1); plot(t,Ld,t,L,'linewidth',2); grid on; legend('Ld','L');
subplot(5,1,2); plot(t,Td,t,T,'linewidth',2); grid on; legend('Td','T');
subplot(5,1,3); plot(t,gx,'linewidth',2); grid on; legend('gx');
subplot(5,1,4); plot(t,gz,'linewidth',2); grid on; legend('gz');
subplot(5,1,5); plot(t,q,'linewidth',2); grid on; legend('q');


%%
%==========================================================================
% I/O linearization
%==========================================================================

% Simulation
Tsim = 30;
DTsim = 0.01;

% Input demand on the second derivative of the x acceleration
d1_step_start = 5;
d1_step_stop  = Tsim+1;
d1_step_initial_value = 0;
d1_step_final_value = 2*(0.1*g)/Tsim^2;

% Input demand on the second derivative of the z acceleration
d2_step_start = 10;
d2_step_stop  = Tsim+1;
d2_step_initial_value = 0;
d2_step_final_value = 2*(g)/Tsim^2;

% Simulation
sim('simulation_model_2');

% Plots
figure;
subplot(4,1,1); plot(t,wx,'linewidth',2); grid on; legend('wx');
subplot(4,1,2); plot(t,wz,'linewidth',2); grid on; legend('wz');
subplot(4,1,3); plot(t,gx,'linewidth',2); grid on; legend('gx');
subplot(4,1,4); plot(t,gz,'linewidth',2); grid on; legend('gz');



%%
%==========================================================================
% I/O linearization and stabilization
%==========================================================================

% Simulation
Tsim = 30;
DTsim = 0.01;

% Input demand on the x acceleration
d1_step_start = 5;
d1_step_stop  = Tsim+1;
d1_step_initial_value = 0;
d1_step_final_value = 0.1*g;

% Input demand on the z acceleration
d2_step_start = 10;
d2_step_stop  = Tsim+1;
d2_step_initial_value = 0;
d2_step_final_value = g;

% Desired Dynamics
T_resp = 1;
epsilon = 0.7;
omega = 4/(epsilon*T_resp);

% Stabilizing feedback gains (PD control)
kp_gx = omega^2;
kd_gx = 2*omega*epsilon;
kp_gz = omega^2;
kd_gz = 2*omega*epsilon;

% Simulation
sim('simulation_model_3');

% Plots
figure;
subplot(5,1,1); plot(t,Ld,t,L,'linewidth',2); grid on; legend('Ld','L');
subplot(5,1,2); plot(t,Td,t,T,'linewidth',2); grid on; legend('Td','T');
subplot(5,1,3); plot(t,gx,t,gxd,'linewidth',2); grid on; legend('gx','gxd');
subplot(5,1,4); plot(t,gz,t,gzd,'linewidth',2); grid on; legend('gz','gzd');
subplot(5,1,5); plot(t,q,'linewidth',2); grid on; legend('q');


%%
%==========================================================================
% Velocity and position control
%==========================================================================

Tsim = 100;
% Gains
Kp_position = 0.4; %0.1
Ki_position = 0.0001; %0.001
Kd_position = 2;
K_speed = 0.1;  %0.1

% Input demand on the x acceleration
d1_step_start = 5;
d1_step_stop  = Tsim+1;
d1_step_initial_value = 0;
d1_step_final_value = 10;

% Input demand on the z acceleration
d2_step_start = 10;
d2_step_stop  = Tsim+1;
d2_step_initial_value = 0;
d2_step_final_value = 5;

sim('simulation_model_4');

% Plots
figure;
subplot(5,1,1); plot(t,Ld,t,L,'linewidth',2); grid on; legend('Ld','L');
subplot(5,1,2); plot(t,Td,t,T,'linewidth',2); grid on; legend('Td','T');
subplot(5,1,3); plot(t,x,t,xd,'linewidth',2); grid on; legend('x','xd');
subplot(5,1,4); plot(t,z,t,zd,'linewidth',2); grid on; legend('z','zd');
%subplot(9,1,5); plot(t,vx,'linewidth',2); grid on; legend('vx');
%subplot(9,1,6); plot(t,vz,'linewidth',2); grid on; legend('vz');
%subplot(9,1,7); plot(t,gx,'linewidth',2); grid on; legend('gx');
%subplot(9,1,8); plot(t,gz,'linewidth',2); grid on; legend('gz');
subplot(5,1,5); plot(t,q,'linewidth',2); grid on; legend('q');


