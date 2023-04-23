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
batt.capacity = 1.5;      % Ah
batt.mass_battery = 126e-3; % (1.5Ah )
batt.internal_resistance=0;

batt.vbat_nom  = batt.nb_element * 3.7;
batt.vbat_full = batt.vbat_nom * 1.135;
batt.vbat_low  = batt.vbat_nom / 1.126;

%%     Drone Parameter        %
%-----------------------------% 
drone.lenght_arm      = 18e-2;       % Distance moteur - centre_de_gravité en m
drone.mass_arm        = 14.5e-3;
drone.diameter_quad   = 50e-2;
drone.height_body     = 10e-2;       % Epaisseur moyenne du drone

drone.mass_autopilot    = 35e-3;
drone.mass_central_body = 25e-3;
drone.mass_payload      = 30e-3; 
motor.mass_motor        = 34e-3;

drone.bias_angle = [0 0 0] ;

if drone.protection
    drone.mass_protection   = 68e-3; 
    drone.Itot = [0.0040  0  0; 0 0.0040  0; 0  0  0.0077];
else
    drone.mass_protection   = 0; 
    drone.mass_central_body = drone.mass_central_body + 20e-3; %% Mass added of the light protection
    drone.Itot = [0.0020  0  0; 0 0.0020  0; 0  0  0.0033];
end

drone.mtot = 4 * (drone.mass_arm + motor.mass_motor)  + drone.mass_autopilot  + drone.mass_central_body + drone.mass_autopilot + batt.mass_battery + drone.mass_central_body +drone.mass_payload +drone.mass_protection;


%%     Motor & Propeller Parameter        %
%-----------------------------------------% 

motor.nominal_voltage =12;        % Nominal Voltage of engine
motor.tr_mot    = 0.05;           % Cte de temps 1er ordre ~ moteurs
motor.wmax      = 420;            % Vitesse hélices max
motor.pwm_max   = 0.90;           % pwm max
motor.pwm_min   = 0.13;           % pwm min
motor.nominal_voltage = 12;
motor.scaling   = 372/0.69;       % nominal speed / nominal thrust
motor.w0 =370;

motor.Pw = 1.0055e-07*(60/2/pi)^2;  % thrust coefficient
motor.Mw = 2.4e-7;                  % moment coefficient
motor.coef_w2P=[motor.Pw;0;0];
motor.coef_w2C=[motor.Mw;0;0];

% speed Vs throttle ( deduced from measurement
speed  =   [ 0  1890 2200  2500  3500  3711 4100 4150 4250]*pi/30;
thrust = motor.Pw.*speed.*speed;
throttle = [ 0  0.2   0.3  0.4   0.65  0.69  0.9 0.95 1];
    [curve, goodness] = fit( throttle',speed', 'poly3' );
motor.coef_t2w=[curve.p1,curve.p2,curve.p3,curve.p4];

% Current Vs Torque ( deduced from  measurement
current   = [ 0 0.6 1   5.8/4  7/4 ];   % Amps
rot_speed = [ 0 100 300  360   380 ]; % rad/s
[curve, goodness] = fit( rot_speed', current', 'poly2' );
motor.coef_w2I=[curve.p1,curve.p2,curve.p3];

% clear intermediate variables
clear current rot_speed curve goodness speed thrust throttle


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








