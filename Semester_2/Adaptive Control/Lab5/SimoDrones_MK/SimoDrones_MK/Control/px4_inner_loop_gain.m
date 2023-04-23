
%%% Gain of Inner loop of Ar drone (In the PX4 board)
%% PX4

regul.px4.Kp_att = [6.5 6.5 2.8];    % proportionnal gain for [roll pitch yaw]
regul.px4.Yaw_ff = 0.5;              % feedforward gain for [roll pitch yaw]

regul.px4.Kp_rate = [0.15 0.15 0.2]; % proportionnal gain for [p q r]
regul.px4.Ki_rate = [0.05 0.05 0.1]; % integral gain for [p q r]
regul.px4.Kd_rate = [0.003 0.003 0]; % derivative gain for [p q r]
regul.px4.ff_rate = [0 0 0];         % feedforward gain for [p q r]

regul.px4.Yaw_move_rate = 0.5;       % maximal yaw rate setpoint
regul.px4.max_rate = [360 360 60];   % maximal rate value for [p q r]


