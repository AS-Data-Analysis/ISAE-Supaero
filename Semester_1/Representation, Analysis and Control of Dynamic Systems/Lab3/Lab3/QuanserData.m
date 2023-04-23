
%Electrical data
Rm = 8.4;   %Terminal resistance (Ohm)
kt = 0.042; %Torque constant (N.m.A^-1)
km = 0.042;  %Motor back emf constant (N.m.A^-1)
Jm = 4e-6;  %Rotor inertia (kg.m^2)
Lm = 1.16e-3;   %Rotor indictance (mH)
%Propeller constants
k1 = 1.2e-5;
k2 = 3.54e-9;
k3 = -9.06e-5;
k4 = 7.83e-7;
Jh = 3.04e-9;   %Propeller hub inertia (kg.m2)
Jp = 7.2e-6;    %Propeller inertia (kg.m^2)
%Total inertia
Jeq = Jm+Jh+Jp;
%Mechanical
Dt = 0.158; %Thrust displacement (m)
Mb = 1.15;  %Aero body mass (kg)
Dm = 0.0071;    %Center of mass displacement (m)
Jp = 2.15e-2;   %Inertia along pitch axis (kg.m^-2)
g = 9.81;
Dp = 0.0071;
