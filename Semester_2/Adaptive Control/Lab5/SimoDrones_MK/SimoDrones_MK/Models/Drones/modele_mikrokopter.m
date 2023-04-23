%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Simulation and Modelisation of Drones  %
%%%    Carte de controle PIXHAWK PX4    %%%
%%%          Mikrokopter drone          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Lisez Moi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Titre : modele_mikrokopter
% Dates : 28/10/2015 
% Auteur : Fran�ois DEFAY - ISAE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%    Battery specification (LiPo)        %
%-----------------------------------------% 
% 1 - batt.mass_battery  = 249g : batt 4s 2.2 Ah 
% 2 - batt.mass_battery  = 329g : batt 4s 3.3 Ah
% 3 - batt.mass_battery  = 367g : batt 4s 3.7 Ah
% 4 - batt.mass_battery  = 443g : batt 4s 4.5 Ah 
% 5 - batt.mass_battery  = 572g : batt 4s 6.0 Ah 

batt.id = 2;
batt.nb_element = 4;          % Number of elementary elements

% batt.mass_battery = 28e-3 * batt.capacity * batt.nb_element; % Very empiric calulation

switch batt.id
    case 1
        batt.capacity = 2.2;        % Ah
        batt.mass_battery = 249e-3;
    case 2
        batt.capacity = 3.3;        % Ah
        batt.mass_battery = 329e-3;
    case 3
        batt.capacity = 3.7;        % Ah
        batt.mass_battery = 367e-3;
    case 4
        batt.capacity = 4.5;        % Ah
        batt.mass_battery = 443e-3;
    case 5
        batt.capacity = 6.0;        % Ah
        batt.mass_battery = 572e-3;
end

batt.internal_resistance=0;

batt.vbat_nom  = batt.nb_element * 3.7;
batt.vbat_full = batt.vbat_nom * 1.135;
batt.vbat_low  = batt.vbat_nom / 1.126;

%%     Drone Parameter        %
%-----------------------------------------% 
% ---- 1 ---  12 inch GWS 12*4.7
% ---- 2 ---  10 inch GWS 10*4.5
% ---- 3 ---  8 inch parrot propeller

prop_id = 2;

switch prop_id
    case 1 
        drone.length_arm      = 28.25e-2;
    case 2
        drone.length_arm      = 22.5e-2;            % Distance moteur - centre_de_gravit� en m
    case 3 
        drone.length_arm      = 22.5e-2;
end

drone.mass_arm        = 50.5e-3;
drone.diameter_quad   = 70e-3;
drone.height_body     = 5e-5;               % Epaisseur moyenne du drone

drone.mass_autopilot    = 60e-3;
drone.mass_central_body = 140e-3;
drone.mass_protection   = 0;
drone.mass_walk         = 140e-3;              % Pieds  
drone.mass_battery      = batt.mass_battery;

drone.mass_payload      = 0.4; % kinnect

drone.mtot = 1.360; 
drone.Itot = [0.0154 0 0; 0 0.0154 0 ; 0 0 0.0299];

drone.bias_angle = [0 0 0];

%%     Motor & Propeller Parameter        %
%-----------------------------------------% 
motor.id = 1;
motor.prop_id  = prop_id;
motor.tr_mot  = 0.1;              % Cte de temps 1er ordre ~ moteurs
motor.wmax = 600;                 % Vitesse helices max
motor.pwm_max   = 0.90;           % pwm max
motor.pwm_min   = 0.13;           % pwm_min
motor.nominal_voltage = 16.5;
motor.operating_voltage = 16;
motor.pourcentage = 10;             % Variation de la cte de temps en %

%Propeller model 
motor.Pw = 1.7999e-05; % Thrust coefficient
motor.Mw = 3.0540e-07; % Moment coefficient

motor.coef_w2P = [1.799904330057872e-05 -0.001264136283221 0.078067815126045];
motor.coef_w2C = [3.054000000000000e-07;1.180000000000000e-05;0.002087000000000];

motor.coef_t2w = [5.425431757422997e+04 -1.909578423463161e+05 2.713116033331229e+05 -1.992737241822052e+05 8.028081517447722e+04 -1.754996584532236e+04 2.747441200311709e+03 0.022279332584889]; 
motor.coef_delta_t2w = [-1.588070360474355e+04 4.759045167577011e+04 -5.643584876915411e+04 3.384519407456877e+04 -1.078412971078039e+04 1.733409183684202e+03 -1.589034782604213e+02 0.024835223961016];
motor.coef_w2I = [7.156271184080908e-11 -5.262806416104326e-08 2.490461268342388e-05 -0.001950135007591 0.005691747418995];
motor.coef_delta_w2I = [-1.517207061236476e-11 2.266651736595326e-08 -1.002300961075331e-05 0.001530922405460 0.001888517549026];


%%     Aerodynamics and environnement coefficients      %
%-----------------------------------------% 

aero.g = 9.81;                    % Constante de gravit�
aero.rho = 1.204;                 % Masse volumique de l'air � 20�C

% Equilibium rotationnal speed for sustentation
motor.w0 = sqrt(drone.mtot*aero.g/4/motor.Pw);
drone.th_0 = 0.48;
motor.scaling = motor.w0/drone.th_0; 

aero.traine_tangage = 3;
aero.traine_roulis = 3;
aero.traine_alt = 0.2;
aero.traine_lacet = 1;

    % Coefficients des autres forces
aero.C_trainee = [26.9081 27.4559 39.2547]*0.2;            % Coefficient de train�e du disque approch� (obtenus par exp�rience)
aero.S_trainee_uvw = [drone.diameter_quad*drone.height_body drone.diameter_quad*drone.height_body pi*(drone.diameter_quad/2)^2];   % surface utile pour la force de train�e
% C_cabrage = [1e-5 1e-5 0];                            % Coefficient de cabrage

% Trainee angulaire (pqr) : m�me coefficient, surface diff�rente, r�sultante en couple
aero.S_trainee_pqr = [pi*(drone.diameter_quad/2)^2 pi*(drone.diameter_quad/2)^2 drone.diameter_quad*drone.height_body];                        % Surfaces actives

%%    Initial state and values            %
%-----------------------------------------% 
motor.initial_speed= 100;

%%     Measure parameters                 %
%-----------------------------------------% 
measure.retard_wifi = 20e-3;
measure.retard_mesure = 10e-3;             % Retard d'acquisition des mesures;
measure.noise_power = 5e-6;
measure.noise_power_angles = 0*1e-7;       % Puissance des bruits de mesure;
measure.noise_power_pqr = 0*1e-5;
measure.noise_power_vit = 0*1e-4;
measure.noise_power_propellers = 0*1e-5;

