%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lead controller
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
t = 0:0.1:20;
t1 = 0:0.1:10;
t2 = 10.1:0.1:20;
% input reference
E = [10*pi*ones(size(t'))/180 [zeros(size(t1'));0.02*ones(size(t2'))]];
% NOTE: we have a pertubation signal that starts at 10
% The objective is to show the robustness of the designed control to torque losses

%**************************************************************************
% getting the open-loop system state representation
%**************************************************************************
% or using modal approach
openloop_linmod = linmod('open_loop_system');
openloop_ss = ss(openloop_linmod.a,openloop_linmod.b,...
    openloop_linmod.c, openloop_linmod.d);

%**************************************************************************
% Lead controller : K*(1+a*tau*s)/(1+tau*s)
%**************************************************************************
% defining phase
%%% HERE please choose the desired phase in degrees (e.g 40)
phase = 40;
phi = phase*pi/180
% defining the a parameter
a = (sin(phi)+1)/(1-sin(phi))

% NOTE 1 : we have a constraint for the motor current Imax = 0.66 A, so we cannot ask more ...
% you need to take into account this constraint and the maximun input current,
% NOTE 2 : please consider a reference step of 10 degrees to that
% HERE : you shall compute the k gain with respect to the current constraint and
% the transitory gain of the controller that is a
k = 1 %0.66/a/10*(180/pi) %TO_BE_COMPLETED % 10 is multiplied because it is a 10 deg step

% next step, you need to compute find the cutoff frequency of the open-loop
% system including the k gain and the gain of the controller (root a)
margins = allmargin(openloop_ss*k*sqrt(a)) %TO_BE_COMPLETED

% gets the cutoff frequency considering from the robustness structure
Wc = margins.GMFrequency %TO_BE_COMPLETED

% then, you shall compute the tau parameter
tau = 0.2672 %1/(Wc*sqrt(a)) %TO_BE_COMPLETED

% Finally, constructs the compensator as
lead = tf(k*[a*tau 1],[tau 1]);

% figure
% step(closeloop_lead_ss)

%**************************************************************************
% Closed-loop analysis 
%**************************************************************************
closedloop_linmod_lead = linmod('closed_loop_system_with_lead');
closedloop_lead_ss = ss(closedloop_linmod_lead.a,closedloop_linmod_lead.b,closedloop_linmod_lead.c, closedloop_linmod_lead.d);
robustness4 = allmargin(closedloop_lead_ss(1,1))


%**************************************************************************
% simulation
%**************************************************************************
y_lead = lsim(closedloop_lead_ss,E,t);

%**************************************************************************
% Time response
%**************************************************************************
figure
subplot(2,1,1)
plot(t,y_lead(:,1),'b','MarkerSize',10,'LineWidth',4)
grid
title('angular position');
subplot(2,1,2)
plot(t,y_lead(:,2),'b','MarkerSize',10,'LineWidth',4)
grid
title('command');
legend( 'lead controller'); 


%**************************************************************************
% Checking delay margin
%**************************************************************************
openloop_linmod_lead = linmod('open_loop_system_with_lead');
open_loop_lead_ss = ss(openloop_linmod_lead.a,openloop_linmod_lead.b,openloop_linmod_lead.c, openloop_linmod_lead.d);
robustness5 = allmargin(open_loop_lead_ss(1,1))

%%% NOTE: this choice of Te is just an example -> you may define the yours
Te = 0.05 %TO_BE_COMPLETED % getting somme thing that is smaller then the limit Te<=2*DM


%%% NOTE: you may use one that is Ok with the real-time tasks requirements
%%% AND ok with the compensantor requirements
sysd_lead = c2d(lead, Te, 'tustin')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To draw the conclusions, you should be able to answer the following questions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Is the system stable and robust to torque loss ?
% The system is stable but robustness depends on the phase value.

% What happens when we fix a bigger margin phase ?
% Increasing the phase increases a. Since there is a current constraint,
% the gain decreases which worsens the performance by increasing the steady
% state error and reducing the time response.

% The k gain is a free parameter ?
% No, it depends on a and the current constraint.

% Considering the current constraint, which is the value of a and k, when a margin phase of 50° is imposed
% a = 7.5486         k = 0.5010

% Could one make use of an integrator in such a controller design to
% suppress the torque loss disturbance?
% No
