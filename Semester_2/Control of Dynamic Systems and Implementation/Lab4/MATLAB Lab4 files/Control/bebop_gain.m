  

% controlGainser parameters of bebop
% This gains can be found in the file controlGainsler.cfg

% Angles
% gainsQuaternionDefault :
  controlGains.pitch.thetaKP = 264.7408; % [s-2]
  controlGains.pitch.thetaKI = 264.7408; % [s-3]
  controlGains.pitch.thetaKD = 33.0926; % [s-1]
  controlGains.pitch.thetaKDD = 0.5295; % No units
  controlGains.pitch.anglemax = 20*pi/180; % [rad]
    
  controlGains.roll.phiKP = 242.5376; % [s-2]
  controlGains.roll.phiKI = 242.5376; % [s-3]
  controlGains.roll.phiKD = 30.3349; % [s-1]
  controlGains.roll.phiKDD = 0.4879; % No units
  controlGains.roll.anglemax = 20*pi/180; % [rad]
  
  controlGains.psi.psiKP = 50.0; % [s-2]
  controlGains.psi.psiKI = 10.0; % [s-3]
  controlGains.psi.psiKD = 11.0; % [s-1]
  controlGains.psi.psiKDD = 0.0; % No units
  
  controlGains.psi.ratemax = 100 *pi/180; % [rad/s]
   
  controlGains.altitude.KP = 5.04;
  controlGains.altitude.KI = 1.4;
  controlGains.altitude.KD = 7;
  controlGains.altitude.KDD = 0.0;
  controlGains.altitude.VZmax = 1.0;
% Speed

  controlGains.vistesse.maxSpeedIntegral = [11.6667, 11.6667]; % [deg]
