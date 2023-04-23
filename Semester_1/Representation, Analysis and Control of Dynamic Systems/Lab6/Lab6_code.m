syms s

% Constants

K = 1e-4
wn1 = 158.336     % Frequency = 25.2 Hz converted to rad/s
zeta1 = 0.0049
Ka = 10
Ks = 100
x0 = 5e-3
zeta2 = 0.05
wn2 = 753.982     % Frequence = 2*pi*120 Hz converted to rad/s


% Open Loop Model

num = K;
den = [1/wn1^2 2*zeta1/wn1 1];

A = [0 1 ; -wn1^2 -2*zeta1*wn1]
B = [0 ; K*wn1^2]

F = tf(num,den)


% Closed Loop with one mode

Kc1 = 0.1256

num1 = K*Ka
den1 = [1/wn1^2 2*zeta1/(wn1)+K*Ka*Kc1*Ks 1];

A1 = [0 1 ; -wn1^2 -2*zeta1*wn1-K*Ka*Kc1*Ks*wn1^2];
B1 = [0 ; K*Ka*wn1^2]

F1 = tf(num1,den1)


% Closed Loop with two modes

num2 = 1;
den2 = [1/wn2^2 2*zeta2/wn2 1];

A2 = [0 1 ; -wn2^2 -2*zeta2*wn2];
B2 = [0 ; wn2^2];

F0 = tf(num2,den2)
F2 = F1*F0

Kc2 = 0.015


% Analysis

hold on
rlocus(F,'k')
rlocus(F1)
rlocus(F2,'-.')
grid on
legend('Open Loop','Closed Loop 1 mode','Closed Loop 2 modes')

figure
hold on
bode(F,'k')
bode(F1)
bode(F2,'-.')
grid on
legend('Open Loop','Closed Loop 1 mode','Closed Loop 2 modes')