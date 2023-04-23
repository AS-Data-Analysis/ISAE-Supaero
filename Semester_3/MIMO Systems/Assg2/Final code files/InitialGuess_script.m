clear all
clc
close all

% Time matrix

Time = (0:0.02:2)';
d2r= pi/180;

% x matrix

pn = linspace(0,4,101)';
pd = ones(101,1);
vn = [linspace(0,2,50) linspace(2,0,51)]';
vd = zeros(1,101)';
the = [linspace(0,1.5*d2r,50) linspace(1.5*d2r,0,51)]';
thed = [linspace(0,1.5*d2r,50) linspace(1.5*d2r,0,51)]';
gam = [linspace(0,1.5*d2r,50) linspace(1.5*d2r,0,51)]';
gamd = [linspace(0,1.5*d2r,50) linspace(1.5*d2r,0,51)]';

x = [pn pd vn vd the thed gam gamd];

% u matrix
%T1 = [linspace(0,12,50) linspace(12,0,51)]';
%T2 = [linspace(0,8,50) linspace(8,0,51)]';
u = 10*ones(101,2);

InitialGuess_drone = struct('Time',Time,'x',x,'u',u);
save InitialGuess_drone.mat InitialGuess_drone

clear pn pd vn vd the thed gam gamd d2r