% Vertical Control

s = tf('s');

% P controller - 1st order system
H = 1/s;
Kp1 = 4;
Hcl = feedback(Kp1*H,1);

% P controller - 2nd order system
tau = 0.33;
G1 = 1/(tau*s^2+s);
Kp2 = 5.2071;
G1cl = feedback(Kp2*G1,1);

% PD controller - 2nd order system
sg = 0.7;
om = 3/sg;
Kpd = tau*om^2;
Kdd = 2*sg*om*tau-1;
PD = Kpd+s*Kdd;
G2cl = feedback(PD*G1,1);

% PID controller - 2nd order system
Kp = 25.23;
Ki = 37.39;
Kd = 3.806;
PID = Kp+s*Kd+Ki/s;
G3cl = feedback(PID*G1,1);

%-----------------------------------------------------------

% Lateral Control

sigma = 0.7;
omega = 2.5;
A = [0 1 ; 0 0];
B = [0 ; 9.81];
P0 = roots([1 2*sigma*omega omega^2]);
K = place(A,B,P0);
K1 = K(1);
K2 = K(2);
N = K1;