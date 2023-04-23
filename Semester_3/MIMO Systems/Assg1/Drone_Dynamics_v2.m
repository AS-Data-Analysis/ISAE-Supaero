clear all
clc

%% Creating a structure for the system's physical properties
drone = struct('drone_mass',1 , 'cup_mass',1  , 'cup_holder_length',1 , 'propeller_arm',1 , 'moment_of_inertia',1 , ...
    'drag_coefficient',0.01 , 'gravity_acc',10 )

%% Initializing inputs

x = [1;0.1;10*pi/180;10*pi/180;5*pi/180;5*pi/180]; % State variables
u = [4.8;5.3]; % Thrust inputs
w = [2;-3]; % External factors

x_dot = drone_dynamics(x,u,w,drone);

function x_dot = drone_dynamics(x,u,w,drone)

% DRONE DYNAMICS
% All values are in S.I. units!!
%x = [ vn, vd, the, thed, gam, gamd ];
%x_dot = [vnd, vdd, thed, thedd, gamd, gamdd ];
%u = [ T1, T2 ];
%w = [ wn, wd ];

%% drone params
md = drone.drone_mass; % mass of drone [in S.I. units]
mc = drone.cup_mass; % mass of cup [in S.I. units]
l = drone.cup_holder_length; % Cup Holder Lever Arm [in S.I. units]
ld = drone.propeller_arm; % Propeller arm [in S.I. units]
J = drone.moment_of_inertia; % moment of inertia [in S.I. units]
Cd = drone.drag_coefficient; % Drag coefficient
g = drone.gravity_acc; % gravity [in S.I. units]
alpha = gam + the; % assuming alpha = theta + gamma

%% Defining Pi matrix

Pi = [ md 0 0 0 0 0 sin(alpha);
       0 md 0 0 0 0 cos(alpha);
       mc 0 0 -mc*l*cos(alpha) 0 -mc*l*cos(alpha) -sin(alpha);
       0 mc 0 mc*l*sin(alpha) 0 mc*l*sin(alpha) -cos(alpha);
       0 0 0 J 0 0 0;
       0 0 1 0 0 0 0;
       0 0 0 0 1 0 0 ]

%% Defining h matrix

h = [ -(u(1)+u(2))*sin(the)-Cd*(x(2)-w(1));
      md*g-(u(1)+u(2))*cosd(x(3))-Cd*(x(2)-w(2));
      -mc*l*(((x(4)+x(6))*pi/180)^2)*sin(alpha);
      mc*g-mc*l*(((x(4)+x(6))*pi/180)^2)*cos(alpha);
      (u(2)-u(1))*ld;
      x(4);
      x(6) ]
%% Calculating x_dot

x_dot = inv(Pi)*h;
x_dot(end)=[]; % to remove the value of F
x_dot(4)=x_dot(4)*180/pi;       % to report the final value of thetad in degrees
x_dot(6)=x_dot(6)*180/pi;       % to report the final value of gammad in degrees

end