%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% poles placement including the analysis for several kp and kv values
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
t = 0:0.1:20;
t1 = 0:0.1:10;
t2 = 10.1:0.1:20;
% input reference
E = [10*pi*ones(size(t'))/180 [zeros(size(t1'));0.02*ones(size(t2'))]];
% NOTE: we have a pertubation signal that starts at 10
% The objective is to show the robustness of the designed control to torque
% losses
%**************************************************************************
% Pole placement, feedback control (modal approach)
%**************************************************************************
% initialisation
ii = 0;
figure
disp("delta and omega values:")
for omega = [1,2,3,4,5] % HERE you may define omega values to test
    ii = ii+1;
    delta = 0.9 % HERE : define a delta value
    omega % for displaying
    lambda = roots([1 2*delta*omega omega^2]); % compute the poles        
      
    % or using modal approach
    openloop_modal_linmod = linmod('open_loop_system_modal');
    openloop_modal_ss = ss(openloop_modal_linmod.a,openloop_modal_linmod.b,...
        openloop_modal_linmod.c, openloop_modal_linmod.d);
    
    % compute gains
    k = place(openloop_modal_ss.a,openloop_modal_ss.b,lambda)
    % NOTE: k(1) = Kv and k(2) = Kp

    %**************************************************************************
    % closed-loop poles
    %**************************************************************************
    closedloop_linmod = linmod('closed_loop_system_modal_kp_kv');
    closedloop_ss = ss(closedloop_linmod.a,closedloop_linmod.b,closedloop_linmod.c, closedloop_linmod.d);
    [CLnum,CLden] = ss2tf(closedloop_ss.a,closedloop_ss.b,closedloop_ss.c,closedloop_ss.d,1);
    hold on
    poles = roots(CLden)
    
    %**************************************************************************
    % simulation
    %**************************************************************************
    y = lsim(closedloop_ss,E,t);

    %**************************************************************************
    % plotting time response and current input control
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
    % Checking delay margin
    %**************************************************************************
    closedloop_linmod = linmod('closed_loop_system_modal_kp_kv_robustness');
    closedloop_ss = ss(closedloop_linmod.a,closedloop_linmod.b,closedloop_linmod.c, closedloop_linmod.d);
    robustness = allmargin(closedloop_ss)
    
end

legend( 'omega = 1','omega = 2','omega = 3', 'omega = 4', 'omega = 5', 'Location', 'northeast');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To draw the conclusions, you should be able to answer the following questions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% What happens when we increase the omega (pulsation) value?
% current increases, time response decreases and robustness increases

% What happens when we increase the delta (damping factor) value?
% oscillations decrease and time response decreases

% Given the constraint on the current (motor limitation), which are the Kv
% and Kp values that should be chosen?
% Kp = 13.1915    Kv = 4.7489

% Could the torque loss be compensated?
% No, can be compensated but not totally compressed

% If not, what one can do to correct it?
% High gain results in better torque compensation but the current needs to be checked.
% An integrator will force the steady state error to zero. But it can
% amplify noise.
