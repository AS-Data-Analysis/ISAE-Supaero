%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D orientation estimation template
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CONFIGURATION and INITIALISATION
dt=0.01;
COM='COM5';
useSimulation = true;
useSimulation_visuals = useSimulation;
%useSimulation_visuals = true;
%% CALIBRATION
% To re-run calibration, just clear MAG0 or run the calibration script
% separately:
if ~exist('MAG0', 'var')
    runcalibration;
end
%% affichage du parallélépipède
launch3D;

%% estimation attitude
qa = 1e-3; %Bruit d'état orientation
ra = 100*ACCVAR(2:3); %Bruit de mesure accéléro. The accelerometer gives inaccurate readingd when moved horizontally fast, assuming it as a rotation
% Hence, we have less confidence in Accelrometer than the Gyrometer
rg = GYRVAR(1); %Bruit de mesure gyro 
% The above values are obtained on tuning and the Filter performs
% satisfactorily well
Q = diag([qa qa]);
R = diag([ra(1) ra(2) rg]);
X=[0 0]'; %Etat : rotation selon x (rad)
P = deg2rad(10)^2*ones(2);

tp=0;
ii=0;
obs = [];
xtrue = [];
xhat = [];
if useSimulation
    imu411('open',COM, 'simimu_2Dmaneuver');
else
    imu411('open',COM);
end
while(1)
    ii=ii+1;
    % Read sensor
    [d, xt] = imu411('read'); %cette lecture est bloquante et cadence la boucle a 0.01s
    obs(:, end+1) = d;
    xtrue(:, end+1) = xt;
    % Rappel :
    % d(1)    = Time                (s)
    % d(2:4)  = Gyroscope     X,Y,Z (°/s)
    % d(5:7)  = Accelerometer X,Y,Z (g)
    
    t=d(1);
    % Predict
    dt = 0.01; % Taking a sample of 0.01s as readings are available every 0.01s
    F = [1 dt ; 0 1]; % Unlike for 1 state X = theta, when the value of F will be just 1, on including theta_derivative,
    % The equation for theta_k+1 = theta_k + delta_t*theta_derivative
    X = F*X;
    P = F*P*F'+Q;
    % Update
    if ~isnan(t)
        Y = [d(6) 
            d(7) 
            d(2)];
        Yhat = [-sin(X(1)) % From dynamic equations
            cos(X(1)) 
            180/pi*(X(2))];
        H = [-cos(X(1)) 0 % On differentiating to linearize
            -sin(X(1)) 0 
            0  180/pi]; % To convert to degrees
        S = H*P*H'+R;
        K = P*H'*inv(S);
        X = X+K*(Y-Yhat);
        P = P-K*S*K';
    end
    
    % Update Visualisation:
    xhat(:, end+1) = [angle2quat(0, 0, -X(1))'; zeros(3,1)];
    DCM_k = angle2dcm(0, 0, X(1), 'ZYX')';
    update3D;
end