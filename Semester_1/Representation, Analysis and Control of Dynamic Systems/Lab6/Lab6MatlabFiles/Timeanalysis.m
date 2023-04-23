close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      CONSTANTES                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal_1 = [-10 10]; % calibre  (Volts)
Fs = 1E3; % Hz

T=10; % acquisition time

N=T*Fs; % point number
t=[0:(N-1)]/Fs; % time vector


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      CONFIGURATION                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = daq.createSession('ni')
chan=s.addAnalogInputChannel('Dev1',0,'Voltage');
chan.Range=Cal_1;
s.Rate = Fs;
s.DurationInSeconds = T;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      time domain analysis                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% acquisition
disp('go !!!');
inputs = s.startForeground();
plot(t,inputs','r'),grid on; title('mesure');

