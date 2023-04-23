%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Simulation and Modelisation of Drones   %
%%%    PX4 board for Inner loop control  %%%
%%%          A.R. Drone model            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Lisez Moi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Titre : modele_ARdrone
% Dates : 21/02/2017 
% Auteur : François DEFAY
% Version : V3 
%           - Improvement of the model and comments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%    Battery specification (LiPo)        %
%-----------------------------------------% 
batt.nb_element=3;       % Number of elementary elements
batt.capacity = 2.7;      % Ah
batt.mass_battery = 160e-3; % (1.5Ah )
batt.internal_resistance=0;

batt.vbat_nom  = batt.nb_element * 3.7;
batt.vbat_full = batt.vbat_nom * 1.135;
batt.vbat_low  = batt.vbat_nom / 1.126;

%%     Drone Parameter        %
%-----------------------------% 
drone.lenght_arm      = 14.45e-2;       % Distance moteur - centre_de_gravité en m
drone.diameter_quad   = 30e-2;
drone.height_body     = 5e-2;       % Epaisseur moyenne du drone

drone.bias_angle = [0 0 0] ;

drone.Itot = [0.001805  0  0; 0 0.001764  0; 0  0  0.003328];
drone.mtot = 0.608;

% camera parameter
drone.fov_camera = degtorad(60);  

%%     Motor & Propeller Parameter        %
%-----------------------------------------% 

motor.nominal_voltage =12;        % Nominal Voltage of engine

motor.tau_mot    = 0.015;           % Cte de temps 1er ordre ~ moteurs
motor.w0        = 8600*pi/30;     % valeur de w0
motor.wmax      = 12000*pi/30;    % Vitesse hélices max
motor.th0       = 0.457;
motor.scaling   = motor.w0/motor.th0;       % nominal speed / nominal thrust

motor.w0_ground  = 7660*pi/30;
motor.th0_ground = 0.385;

motor.pwm_max   = 0.90;           % pwm max
motor.pwm_min   = 3000*pi/30/motor.scaling;           % pwm min

motor.Pw = 2.15e-8*(60/2/pi)^2;  % thrust coefficient [N.RAD-2]
motor.Mw = 2.85e-10*(60/2/pi)^2; % moment coefficient [N.m.RAD-2]
motor.coef_w2P=[motor.Pw;0;0];
motor.coef_w2C=[motor.Mw;0;0];

poussee_0 = 4 * motor.Pw * motor.w0^2;

% clear intermediate variables
clear current rot_speed curve goodness speed thrust throttle poussee_0


%%     Aerodynamics and environnement coefficients      %
%-----------------------------------------% 

aero.g = 9.81;                    % Constante de gravité
aero.rho = 1.204;                 % Masse volumique de l'air à 20°C
aero.traine_tangage = 3;
aero.traine_roulis = 3;
aero.traine_alt = 5;


% Coefficients des autres forces
aero.C_trainee = [aero.traine_tangage aero.traine_roulis aero.traine_alt];            % Coefficient de trainée du disque approché (obtenus par expérience)
aero.S_trainee_uvw = [drone.diameter_quad*drone.height_body drone.diameter_quad*drone.height_body pi*(drone.diameter_quad/2)^2];   % surface utile pour la force de trainée
% C_cabrage = [1e-5 1e-5 0];                            % Coefficient de cabrage

% Trainee angulaire (pqr) : même coefficient, surface différente, résultante en couple
aero.S_trainee_pqr = [pi*(drone.diameter_quad/2)^2 pi*(drone.diameter_quad/2)^2 drone.diameter_quad*drone.height_body];                        % Surfaces actives

%%     other parameters                 %
%-----------------------------------------% 
measure.retard_wifi = 20e-3;
measure.retard_mesure = 10e-3;             % Retard d'acquisition des mesures;
measure.noise_power = 0;
measure.noise_power_angles = 0*1e-7;       % Puissance des bruits de mesure;
measure.noise_power_pqr = 0*1e-5;
measure.noise_power_vit = 0*1e-5;
measure.noise_power_propellers = 0*1e-5;








