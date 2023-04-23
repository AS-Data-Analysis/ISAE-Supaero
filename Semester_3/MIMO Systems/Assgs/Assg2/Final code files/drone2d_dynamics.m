
function x_dot = drone_dynamics(x,u, drone)
% DRONE_DYNAMICS 
% All values are in S.I. units!!
%   x = [pn pd vn vd the thed gam gamd]
%   u = [T1; T2]
%   w = [wn; wd]
%   drone = structure containing all drone physical parameters (e.g., mass,
%   length)

%% Drone params[in S.I. units]

md = drone.md; % mass of drone
mc = drone.mc; % mass of cup
l = drone.l; % cup to center of mass 
ld = drone.ld; % propeller to center of mass
J = drone.J; % moment of inertia
Cd = drone.Cd; % g coefficient drag
g = drone.g; % gravity
w = [0;0]; % simulating wind

%% Init variables

the = x(5); % all angles are in radians
gam = x(7);
alp = the+gam;
T1 = u(1);
T2 = u(2); % in Newtons

%% Defining matrices
% A*sol = B - Defined in accordance with the equation 23

A = [md  0         0                0          (sin(alp));
      0  md        0                0          (cos(alp));
      mc 0  (-mc*l*cos(alp)) (-mc*l*cos(alp))  (-sin(alp));
      0  mc (mc*l*sin(alp))  (mc*l*sin(alp))   (-cos(alp));
      0  0         J                0               0    ];
  
B = [(-(T1+T2)*sin(the)-Cd*(x(3)-w(1)));
    (md*g-(T1+T2)*cos(the)-Cd*(x(4)-w(2)));
       (-mc*l*((x(6)+x(8))^2)*sin(alp));
      (mc*g-mc*l*((x(6)+x(8))^2)*cos(alp));
                ((T2-T1)*ld)              ];

sol = A\B;

%% Obtaining x_dot from above

x_dot = zeros(8,1);
x_dot(1:2) = x(3:4);
x_dot(3:4) = sol(1:2);
x_dot(5) = x(6);
x_dot(6) = sol(3);
x_dot(7) = x(8);
x_dot(8) = sol(4);

end