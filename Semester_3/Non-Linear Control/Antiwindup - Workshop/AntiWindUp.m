clear all
clc
close all

Ki = 0.5372;
Kp = 1.4968;
Kd = 1.6797;

sys = linmod('AntiWindUp_model');

[num,den] = ss2tf(sys.a,sys.b,sys.c,sys.d);
nyquist(-tf(num,den),{0.3,20})

%omega = [0.1:0.01:1];
%[reF,imG] = nyquist(-sys,omega);
%imG = squeeze(imG);
%plot(omega,imG)
%grid on