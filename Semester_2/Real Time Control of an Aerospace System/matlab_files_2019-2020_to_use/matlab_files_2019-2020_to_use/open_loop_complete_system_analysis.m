%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open-loop system analysis - complete model implemented from Laplacien
% Equations - see open_loop_complet_system simulink file
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
Jp=0.0124;
Jpl=0.0124;
Jw=Jp/100;
ke=0.0001;
%kp = 4;

%**************************************************************************
% ploting the rootlocus graph to poles analysis
%**************************************************************************
openloop_linmod = linmod('open_loop_complet_system')
openloop_ss = ss(openloop_linmod.a,openloop_linmod.b,openloop_linmod.c, openloop_linmod.d)
[OLnum,OLden] = ss2tf(openloop_ss.a,openloop_ss.b,openloop_ss.c,openloop_ss.d,1)
rlocus(OLnum(1,:),OLden) % NOTE: this rootlocus considers the platform angular position as output
%step(OLnum(1,:),OLden)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To draw the conclusions, you should be able to answer the following questions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Is it a stable system? No, there are unstable poles.
% How many poles we have? 4 in total
% Which poles are related with the electrical part? the fast pole
% which poles are related with the mechanical part? the rest
% which part (mechanical/electrical) imposes a dominant dynamics? the
% mechanical (slower poles)
% which poles (and consequently parts of the model) can be ignorated in order to simply the model at hand?
% the electrical part (not a dominant dynamic) and the wheel branch (not
% concerned with the wheel dynamic)