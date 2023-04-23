close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      CONSTANTES                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal_1 = [-10 10]; % calibre (Volts)
Fs = 1E3; % Hz
T=5; % acquisition time
N=T*Fs;
t=[0:(N-1)]/Fs;
Tc=1; % computation time
Nc=Tc*Fs;
ampli=1; % amplitude
ready=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      CONFIGURATION                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% déclaration et configuration de la sortie 0 pour la carte ou 1 pour Matlab
ao = daq.createSession('ni')
ao.Rate = Fs;
ao.addAnalogOutputChannel('Dev1', 0, 'Voltage');

% déclaration et configuration de l'entrée 0 pour la carte ou 1 pour Matlab
ai = daq.createSession('ni')
ai.Rate = Fs;
ai.addAnalogInputChannel('Dev1',0,'Voltage');
ai.Channels(1,1).Range=Cal_1;
ai.DurationInSeconds = T;

ai.NotifyWhenDataAvailableExceeds = ceil(N);
ai.addlistener('DataAvailable',@get_Data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Frequency domain analysis                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% frequency range 
f=24.8:0.05:25.8;
Nf=length(f);

% measure  frequency by frequency
for ind=1:Nf,
    %  measure
    sig = ampli*sin(2*pi*f(ind)*[0:(N-1)]/Fs)';
    ao.queueOutputData(sig);
    ai.startBackground();
    ao.startBackground();
    while(ready==0)
        pause(0.001)
    end
    ready=0;
    while(ao.IsRunning==1)
        pause(0.001)
    end
   
    % computation
    e=hilbert(sig((N-Nc):end));
    r=hilbert(s((N-Nc):end));
    H(ind)=mean(r./e);
    % plot point by point
    figure(1);
    subplot(2,1,1),plot(f(ind),20*log10(abs(H(ind))),'b+'),hold on,grid on,xlabel('Fréquence (Hz)'),ylabel('Gain (dB)'),title(['frequence ' num2str(f(ind))]);
    subplot(2,1,2),plot(f(ind),180/pi*angle(H(ind)),'r+'),hold on,grid on,xlabel('Fréquence (Hz)'),ylabel('phase (°)');
    pause(5);
end

% line plot
figure(1);
subplot(2,1,1),plot(f,20*log10(abs(H)),'b+-'),hold on,grid on,xlabel('Fréquence (Hz)'),ylabel('Gain (dB)'),title(['frequence ' num2str(f)]);
subplot(2,1,2),plot(f,180/pi*angle(H),'r+-'),hold on,grid on,xlabel('Fréquence (Hz)'),ylabel('phase (°)');

