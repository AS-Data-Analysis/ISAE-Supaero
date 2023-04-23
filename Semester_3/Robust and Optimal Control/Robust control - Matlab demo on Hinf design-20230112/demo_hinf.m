%###########################
%  MATLAB DEMO - HINF DESIGN
%###########################
%
% simple model of a rigid satelite: theta(s) = 1/(J*s^2) * u(s)
% theta = pointing angle
% u = commanded torque
%
% closed-loop objectives:
% 1. track a second-order reference model (xi=0.7 and omega=2.5rad/s)
% 2. avoid large values of the control input u (actuator saturations)
% 3. ensure robustness in the presence of uncertainties on the inertia
%
clear variables
close all
%
J=0.5; % nominal value of the inertia
%
%################################################
%  First tuning: using static weighting functions
%################################################
%
% weighting functions
num1=1;den1=1;  % W1=1 (performance channel between w and z1)
num2=1;den2=1;  % W2=1 (control channel between w and z2)
%
% open-loop plant P(s)
[a,b,c,d]=linmod('designModel1');
P=ss(a,b,c,d);
%
% full-order design
r=[3 1]; % 2 measurements + 1 reference input ; 1 control input
[K,Gc,gopt]=hinfreg(P,r,100);  % gopt = 0.781
damp(K)
damp(Gc)
% => a fourth-order controller is obtained since the order of P is 4 (two integrators
%    + second-order reference model)
%
% time-domain simulation
simModel1;
% => large static error
% => small control amplitude = 0.05  => increase W1 or decrease W2
%
%#################################################
%  Second tuning: using static weighting functions
%#################################################
%
% weighting functions
num1=1;den1=1;    % W1=1 (performance channel between w and z1)
num2=0.1;den2=1;  % W2=0.1 (control channel between w and z2)
%
% open-loop plant P(s)
[a,b,c,d]=linmod('designModel1');
P=ss(a,b,c,d);
%
% full-order design
r=[3 1];
[K,Gc,gopt]=hinfreg(P,r,100);  % gopt = 0.293
damp(K)
damp(Gc)
%
% time-domain simulation
simModel1;
% => static error is reduced but is still there
% => control activity = 0.23
%
%################################################
%  Third tuning: using static weighting functions
%################################################
%
% weighting functions
num1=1;den1=1;     % W1=1 (performance channel between w and z1)
num2=0.01;den2=1;  % W2=0.01 (control channel between w and z2)
%
% open-loop plant P(s)
[a,b,c,d]=linmod('designModel1');
P=ss(a,b,c,d);
%
% full-order design
r=[3 1];
[K,Gc,gopt]=hinfreg(P,r,100);  % gopt = 0.098
damp(K)
damp(Gc)
%
% time-domain simulation
simModel1;
% => static error is reduced and almost acceptable
% => control activity = 0.43
%
%###################################################
%  Forth tuning: using a low-pass performance filter
%###################################################
%
% weighting functions
W10=200;
tau=100;
num1=200;den1=[tau 1];  % W1=W10/(1+tau*s) (performance channel between w and z1)
num2=0.07;den2=1;       % W2=0.07 (control channel between w and z2)
%
figure(1)
bode(tf(num1,den1),logspace(-3,2,100));  % Bode plot of W1
hold on,grid on
bode(tf(6.25,[1 3.5 6.25]));             % Bode plot of the reference model
% => W1 is tuned so that |W1(w)| satisfies |W1(2)|=1, i.e. wc=2 rad/s
% => this corresponds approximately to the bandwidth of the reference model
%
% open-loop plant P(s)
[a,b,c,d]=linmod('designModel1');
P=ss(a,b,c,d);
%
% 1. full-order design
r=[3 1];
[K,Gc,gopt]=hinfreg(P,r,100);  % gopt = 0.195
damp(K)
damp(Gc)
%
% time-domain simulation
simModel1;
% => very low static error
% => control activity = 0.32
% => much better results than with constant weighting functions
%
% 2. fixed-order design with hinfstruct
K0=ltiblock.gain('K0',1,3);  % static controller (3 measurements, 1 control input)
opt=hinfstructOptions('randomstart',3);
[Kf,gopt]=hinfstruct(P,K0,opt);  % gopt = 0.175
K=ss(Kf);
damp(feedback(P,K,2,3:5,1))
%
% time-domain simulation
simModel1;
% => very low static error
% => control activity = 0.43
% => closed-loop poles very close to the reference model (xi~0.69 and w~2.24rad/s)
% => gamma smaller than with the full-order controller (in fact, the latter leads to
%    a slightly better value of gamma (0.1724) if the tolerance in hinfsyn is set to
%    0.001, but a very fast pole appears in K and the time-domain simulations are not
%    satisfactory)
% => results similar to the full-order case with a static controller except the
%    control activity which is slightly larger
%
%#############################################
%  Controller design without speed measurement
%#############################################
%
% weighting functions
W10=200;
tau=100;
num1=200;den1=[tau 1];  % W1=W10/(1+tau*s) (performance channel between w and z1)
num2=0.07;den2=1;       % W2=0.07 (control channel between w and z2)
%
% open-loop plant P(s)
[a,b,c,d]=linmod('designModel2');
P=ss(a,b,c,d);
%
% 1. full-order design
%
r=[2 1]; % 1 measurement + 1 reference input ; 1 control input
[K,Gc,gopt] = hinfreg(P,r,1);  % gopt = 0.188 => same as before!
damp(K)
damp(Gc)
%
% time-domain simulation
simModel2;
% => very low static error
% => control activity = 0.33
% => same results as before even if the speed measurement is not available
%
% 2. fixed-order design with hinfstruct
%
K0=ltiblock.gain('K0',1,2);  % static controller (2 measurements, 1 control input)
opt=hinfstructOptions('randomstart',3);
[Kf,gopt]=hinfstruct(P,K0,opt);  % fail to enforce closed-loop stability
K=ss(Kf);
% => a double integrator cannot be stabilized by a static controller if only the
%    position measurement is available (see root locus below)
figure
subplot(1,2,1),rlocus(P(4,2));  % transfer between measured position and control input
subplot(1,2,2),rlocus(-P(4,2));
% 
K0=ltiblock.ss('K0',1,1,2);  % 1st order controller (2 measurements, 1 control input)
opt=hinfstructOptions('randomstart',3);
[Kf,gopt]=hinfstruct(P,K0,opt);  % gopt = 0.173 => same as before!
K=ss(Kf);
damp(K)
damp(feedback(P,K,2,3:4,1))
%
% time-domain simulation
simModel2;
% => very low static error
% => control activity = 0.43
% => same results as before even if the speed measurement is not available, but a 1st
%    order controller is needed to estimate the velocity which is not measured anymore
%
%###########################################
%  Controller design with uncertainties on J
%###########################################
%
% 1. Evaluation of the different criteria for the previous controller
%
[a,b,c,d]=linmod('analysisModel');
CL=ssbal(ss(a,b,c,d));
W1=tf(num1,den1);
W2=tf(num2,den2);
normhinf(blkdiag(W1,W2)*CL(1:2,1))
% => gamma = 0.173 (same result as above)
normhinf(CL(3,2))
% => gamma ~ 1.44 (can slightly vary due to random initialization of hinfstruct)
% => stability proved for J=J0*(1+/-deltaJ) with |deltaJ| < 1/1.44 = 0.69 (small gain
%    theorem), ie 69% multiplicative uncertainty
%
% 2. New design taking into account the uncertainty on J
%
% the Hinf norm of the transfer between [w1;w2] and [z1;z2;z3] is minimized
%
% weighting functions
W10=200;
tau=100;
num1=200;den1=[tau 1];  % W1=W10/(1+tau*s) (performance channel between w1 and z1)
num2=0.07;den2=1;       % W2=0.07 (control channel between w1 and z2)
num3=0.16;den3=1;       % W3=0.16 (uncertainty channel between w2 and z3)
%
% open-loop plant P(s)
[a,b,c,d]=linmod('designModel3');
P=ss(a,b,c,d);
%
% fixed-order design with hinfstruct
K0=ltiblock.ss('K0',2,1,2);  % 2nd order controller (2 measurements, 1 control input)
opt=hinfstructOptions('randomstart',10);
[Kf,gopt]=hinfstruct(P,K0,opt);  % gopt = 0.559
K=ss(Kf);
damp(K)
% => a second-order controller is required (gopt>5 for a first-order controller, and
%    no improvement if the order is larger than 2)
% => the poles of the controller are not very satisfactory (one is slow around -1e-2
%    and one is fast around -1e2), so numerical problems can be expected
%
% evaluation of the different criteria
[a,b,c,d]=linmod('analysisModel');
CL=ssbal(ss(a,b,c,d));
normhinf(blkdiag(W1,W2)*CL(1:2,1))
% => gamma ~ 0.51 => degradation of performance and control activity
normhinf(CL(3,2))
% => gamma ~ 1.08 (between 1.01 and 1.20) => robustness improvement
% => stability proved for J=J0*(1+/-deltaJ) with |deltaJ| < 1/1.08 = 0.92 (small gain
%    theorem), ie 92% multiplicative uncertainty
% => robustness has been improved, but a significant degredation of performance and/or
%    control activity is observed
%
% time-domain simulation
simModel2;
% => the reference model is not tracked very well and numerical problems can be
%    observed (see control input plot)
%
% 3. New design taking into account two different objectives
%
% instead of minimizing the Hinf norm of a single transfer between [w1;w2] and
% [z1;z2;z3], the following problem is considered:
% min gamma such that ||w1->[z1;z2]||_inf < gamma    (performance + control activity)
%                     ||w2->z3||_inf < gamma         (uncertainty rejection)
% solving this problem is possible with hinfstruct, but not with the old full-order
% routine hinfsyn (which can only minimize the norm of a single transfer)
%
% fixed-order design with hinfstruct
K0=ltiblock.ss('K0',1,1,2);  % 1st order controller (2 measurements, 1 control input)
CL0=lft(P,K0);
CL1=CL0(1:2,1);         % mixed-sensitivity
CL2=CL0(3,2);           % uncertainty rejection
CL0f=blkdiag(CL1,CL2);  % concatenation of both Hinf constraints
options=hinfstructOptions('RandomStart',10);
[CL,gopt]=hinfstruct(CL0f,options);  % gopt = 0.175
K=ss(CL.Blocks.K0);
damp(K)
% => a first-order controller is sufficient
% => the controller pole is around -45, so numerical problems should be avoided 
%
% evaluation of the different criteria
[a,b,c,d]=linmod('analysisModel');
CL=ssbal(ss(a,b,c,d));
normhinf(blkdiag(W1,W2)*CL(1:2,1))
% => gamma ~ 0.175 => no degradation of performance and control activity
normhinf(CL(3,2))
% => gamma ~ 1.07 => robustness improvement
% => stability proved for J=J0*(1+/-deltaJ) with |deltaJ| < 1/1.07 = 0.93 (small gain
%    theorem), ie 93% multiplicative uncertainty
% => robustness has been improved, and no significant degredation of performance
%    and/or control activity is observed
%
% time-domain simulation
simModel2;
sys=linmod('simModel2');
damp(sys.a)
% => no numerical problem can be observed
% => the reference model is correctly tracked
% => the closed-loop poles are satisfactory (second-order system with omega~2.2rad/s
%    and xi~0.69 very close to the reference model + controller pole at around -40)
