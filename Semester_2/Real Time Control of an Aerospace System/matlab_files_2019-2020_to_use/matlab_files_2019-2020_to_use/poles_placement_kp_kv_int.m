%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% poles placement using previous results to set the integrator gain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
clc
close all

%**************************************************************************
% Defining constant model parameters values
%**************************************************************************
L=0.050;
R=9.7;
ki=1;
km=0.0235;
Jpl=0.0124;
Jw=Jpl/100;
ke=0.0001;

%**************************************************************************
% defining input signal and temporal vector for simulation purposes
%**************************************************************************
tt = ['b', 'g', 'r', 'm', 'c'];
% Time
t = 0:0.1:30;
t1 = 0:0.1:10;
t2 = 10.1:0.1:20;
t3 = 20.1:0.1:30;
% input reference
E = [10*pi*ones(size(t'))/180 [zeros(size(t1'));0.02*ones(size([t2 t3]'))] [zeros(size([t1 t2]')); 0.03*sin(10*t2')]];
% NOTE: we have a pertubation signal that starts at 10 ant a sinusoid that
% starts at 20 now
% The objective is to show the robustness of the designed control to torque
% losses and its sensibility to noise measurements


%**************************************************************************
% Pole placement, control feedback -> this part concerns the results of
% the previous exercise, please adapt this part following your results
%**************************************************************************
% initialisation
ii = 0;
figure
delta = 0.9; %% HERE use your delta value, w.r.t previous exercise
omega = 2.7; %% HERE use your omega value, w.r.t previous exercise
ii = ii+1;
% compute poles
lambda = roots([1 2*delta*omega omega^2]);

% using modal approach
openloop_modal_linmod = linmod('open_loop_system_modal');
openloop_modal_ss = ss(openloop_modal_linmod.a,openloop_modal_linmod.b,...
    openloop_modal_linmod.c, openloop_modal_linmod.d);
% compute gain
k = place(openloop_modal_ss.a,openloop_modal_ss.b,lambda)

%**************************************************************************
% closed-loop poles
%**************************************************************************
closedloop_linmod = linmod('closed_loop_system_modal_kp_kv_noise');
%closedloop_linmod = linmod('closed_loop_system_modal_kp_kv');
closedloop_ss = ss(closedloop_linmod.a,closedloop_linmod.b,closedloop_linmod.c, closedloop_linmod.d);
[CLnum,CLden] = ss2tf(closedloop_ss.a,closedloop_ss.b,closedloop_ss.c,closedloop_ss.d,1);
hold on
poles=roots(CLden)
    
%**************************************************************************
% simulation
%**************************************************************************
y = lsim(closedloop_ss,E,t);

%**************************************************************************
% Time response
%**************************************************************************
subplot(2,1,1)
plot(t,y(:,1),tt(ii),'MarkerSize',10,'LineWidth',2)
hold on
title('angular position');
subplot(2,1,2)
plot(t,y(:,2),tt(ii),'MarkerSize',10,'LineWidth',2)
hold on
title('command');
 
%**************************************************************************
% Pole placement WITH INTEGRATOR, control feedback ->
% complete the following code
%**************************************************************************
% using modal approach
openloop_modal_int_linmod = linmod('open_loop_system_modal_kp_kv_int');
openloop_modal_int_ss = ss(openloop_modal_int_linmod.a,openloop_modal_int_linmod.b,...
    openloop_modal_int_linmod.c, openloop_modal_int_linmod.d);

lambda = [ roots([1 2*delta*omega omega^2]); -3]; %% HERE : choose the 3rd pole
k = place(openloop_modal_int_ss.a,openloop_modal_int_ss.b,lambda)
% NOTE: k(1) = Kv, k(2) = Kp and k(3) = Ki
    
%**************************************************************************
% close loop poles with integrator
%**************************************************************************
closedloop_int_linmod = linmod('closed_loop_system_modal_kp_kv_int');
closedloop_int_ss = ss(closedloop_int_linmod.a,closedloop_int_linmod.b,closedloop_int_linmod.c, closedloop_int_linmod.d);
[CLnum,CLden] = ss2tf(closedloop_int_ss.a,closedloop_int_ss.b,closedloop_int_ss.c,closedloop_int_ss.d,1);
hold on
poles=roots(CLden)

%**************************************************************************
% simulation
%**************************************************************************
y = lsim(closedloop_int_ss,E,t);

%**************************************************************************
% Time response
%**************************************************************************
ii = ii + 2
subplot(2,1,1)
plot(t,y(:,1),tt(ii),'MarkerSize',10,'LineWidth',2)
hold on
title('angular position');
subplot(2,1,2)
plot(t,y(:,2),tt(ii),'MarkerSize',10,'LineWidth',2)
hold on
title('command');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Legend to compare results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legend( 'without integrator' ,'with integrator', 'Location', 'northeast');

%**************************************************************************
% Checking delay margin
%**************************************************************************
closedloop_int_linmod = linmod('open_loop_system_modal_kp_kv_int_robustness');
closedloop_int_ss = ss(closedloop_int_linmod.a,closedloop_int_linmod.b,closedloop_int_linmod.c, closedloop_int_linmod.d);
robustness3 = allmargin(closedloop_int_ss(1,1))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To draw the conclusions, you should be able to answer the following questions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Is the torque loss compensated?
% Yes, the integrator forces the steady state error to 0.

% What happens when we use a smaller (e.g -10 instead of -2) value for the
% pole related with the integrator?
% Making the pole faster makes the integrator amplify noise even more. The
% system is more sensitive to noise but error correction is faster. The
% current intensity required is increased when the noise hits.

% Could it instabilize the system?
% There is a limit after which any system can become unstable due to
% disturbances. For example, if the current is saturated due to the
% amplitude of the noise, it can destabilize the system.

% Which are the Kv, Kp, Ki gains retained?
% You make the system more robust at the same current intensity but at the
% cost of time response.
% Kv = 3.0921     Kp = 6.4111 Ki = -3.8466
