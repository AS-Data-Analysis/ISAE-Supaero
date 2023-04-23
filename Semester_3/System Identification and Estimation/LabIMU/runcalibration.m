%Initialisation Kalman
if useSimulation
    imu411('open',COM, 'simimu_static.mat');
else
    imu411('open',COM);
end
dd=[];
disp('placer l''IMU a plat et presser une touche pour lancer l''acquisition de calibration');
pause;
T_calibration = 1;
for t=0:dt:T_calibration
    dd=[dd imu411('read')];
    disp([mfilename '>> Calibration: ' num2str(100*t/T_calibration) '%']);
end
imu411('close');
disp('fin acquisition');
%Réparation : en cas de timout la fonction 'read' reanvoit NaN : il
%faut supprimer ces éléments
ind=find(~isnan(dd(1,:)));
dd=dd(:,ind);

MAG0 = mean(dd(8:10,:),2);
ACC0 = mean(dd(5:7,:),2);
GYR0 = mean(dd(2:4,:),2);
MAGVAR = var(dd(8:10,:)')';
ACCVAR = var(dd(5:7,:)')';
GYRVAR = var(dd(2:4,:)')';