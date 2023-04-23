%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3D orientation estimation template
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CONFIGURATION and INITIALISATION
dt=0.01;
COM='COM5';
useSimulation = true;
useSimulation_visuals = useSimulation;
%% CALIBRATION
% To re-run calibration, just clear MAG0 or run the calibration script
% separately:
if ~exist('MAG0', 'var')
    runcalibration;
end
%% affichage du parallélépipède
launch3D;

%% estimation attitude
qa = 1;    %Bruit d'état
ra = 10; %Bruit de mesure accéléro
rm = 20;
Q = diag([qa qa qa qa]);
R = diag([ra ra ra]);
X=[1 0 0 0]'; %Etat : quaternion
P = 1000*eye(4);

tp=0;
ii=0;
obs = [];
xtrue = [];
xhat = [];
if useSimulation
    imu411('open',COM, 'simimu_3Dmaneuver');
else
    imu411('open',COM);
end
while(1)
    ii=ii+1;
    % read sensor
    [d, xt] = imu411('read'); %cette lecture est bloquante et cadence la boucle a 0.01s
    obs(:, end+1) = d;
    xtrue(:, end+1) = xt;    %Rappel
    % d(1)    = Time                (s)
    % d(2:4)  = Gyroscope     X,Y,Z (°/s)
    % d(5:7)  = Accelerometer X,Y,Z (g)
    % d(8:10) = Magnetometer  X,Y,Z (Gauss)
    t=d(1);
    % Predict
    X = X;
    F = eye(4);
    P = F*P*F'+Q;
    % Update
    if ~isnan(t)
        Y =[d(5)    %accX
            d(6)    %accY
            d(7)    %accZ
            ];
        M=quat2M(X(1:4))';
        Yhat = [M*ACC0
            ];
        q0=X(1);
        q1=X(2);
        q2=X(3);
        q3=X(4);
        J1=2*[q0 q1 -q2 -q3
            -q3 q2 q1 -q0
            q2 q3 q0 q1];
        J2=2*[q3 q2 q1 q0
            q0 -q1 q2 -q3
            -q1 -q0 q3 q2];
        J3=[-q2 q3 -q0 q1
            q1 q0 q3 q2
            q0 -q1 -q2 q3];
        Hacc=J1*ACC0(1)+J2*ACC0(2)+J3*ACC0(3);
        H=[Hacc
            ];
        G = H*P*H'+R;
        K = P*H'*inv(G);
        X = X+K*(Y-Yhat);
        X(1:4) = X(1:4)/norm(X(1:4));
        P = P - P*K*H;
        xhat(:, end+1) = X;
    end
    
    % Update 3D visualization:
    %DCM_k = quat2dcm(X(1:4)');
    DCM_k = quat2dcm(X(1:4)'/norm(X(1:4)))';
    update3D;
end

