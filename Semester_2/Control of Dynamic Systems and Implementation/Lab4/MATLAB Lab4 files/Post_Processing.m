% Vertical Control
close all

%{
% P controller - 1st order system
figure(1)
plot(ztest1_p1.time,ztest1_p1.data,out.optitrack.z.time,out.optitrack.z.data,zmodel_P1.Time,zmodel_P1.Data)
legend('experiment','bebop simulator','simplified 1st order model')
%}

%{
% P controller - 2nd order system
figure(2)
plot(ztest2_p2.time,ztest2_p2.data,out.optitrack.z.time,out.optitrack.z.data,zmodel_P2.Time,zmodel_P2.Data)
legend('experiment','bebop simulator','simplified 2nd order model')
%}

%{
% PD controller - 2nd order system
figure(3)
plot(ztest3_pd.time,ztest3_pd.data,out.optitrack.z.time,out.optitrack.z.data,zmodel_PD2.Time,zmodel_PD2.Data)
legend('experiment','bebop simulator','simplified 2nd order model')
%}

%{
% PID controller - 2nd order system
figure(4)
plot(out.optitrack.z.time,out.optitrack.z.data,zmodel_PID2.Time,zmodel_PID2.Data)
legend('bebop simulator','simplified 2nd order model')
%}

%--------------------------------------------------------------------------

% Lateral Control

%{
% X control
figure(5)
plot(xtest4_lat.time,xtest4_lat.data,out.optitrack.x.time,out.optitrack.x.data,xmodel.Time,xmodel.Data)
legend('experiment','bebop simulator','simplified model')
%}

%{
% Y control
figure(6)
plot(ytest4_lat.time,ytest4_lat.data,out.optitrack.y.time,out.optitrack.y.data,ymodel.Time,ymodel.Data)
legend('experiment','bebop simulator','simplified model')
%}