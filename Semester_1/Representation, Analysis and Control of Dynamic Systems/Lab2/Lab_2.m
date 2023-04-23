syms s

N = 300;
Jm = 0.001;
ke = 0.2;
km = 0.2;
R = 2;
L = 0.002;

J = 100;
K = 10000;
b = 10;

Jt = J+Jm*N^2;

%--------- No Load ----------

num1 = N*km;
den1 = [Jt*L Jt*R ke*km*N^2 0];

%roots(den1)

sys1 = tf(num1,den1);

%[z,p,k] = zpkdata(sys,'v');

%bode(sys1); grid on; hold on;
%nichols(sys1)
%rlocus(sys1)
%ltiview(sys1)

%[Gm,Pm,Wcg,Wcp] = margin(sys)
%MdB = 20*log10(Gm)

%sys1sim = linmod('open_loop_satellite_noload');
%open_loop_satellite = ss(sys1sim.a,sys1sim.b,sys1sim.c,sys1sim.d)
%figure
%bode(open_loop_satellite)
%step(open_loop_satellite)
%grid on
%damp(sys1sim.a)

% ------------ Load --------------

num2 = N*km;
den2 = [Jt*L Jt*R+L*b N^2*km*ke+R*b+L*K R*K];
sys2 = tf(num2,den2);
roots(den2)
%bode(sys2); grid on; hold on;
%ltiview(sys2); grid on;

sys2sim = linmod('open_loop_satellite_load');
open_loop_satellite = ss(sys2sim.a,sys2sim.b,sys2sim.c,sys2sim.d)
%figure
bode(open_loop_satellite); grid on; hold on;
%damp(sys2sim.a)

ltiview(open_loop_satellite);
%rlocus(open_loop_satellite)
%grid on