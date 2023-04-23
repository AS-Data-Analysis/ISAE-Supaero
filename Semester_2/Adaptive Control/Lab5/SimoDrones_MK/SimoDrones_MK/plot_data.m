% TO save date in othe file
% save test.mat

%% optitrack data:

% optitrack.x   
% optitrack.y
% optitrack.z
% optitrack.Vx
% optitrack.Vy
% optitrack.Vz
% optitrack.att (roll, pitch, yaw)
% optitrack.time

%%     px4 data     

% px4.att           : output of kalman filter of px4 (roll, pitch, yaw)
% px4.att_tgt.roll  : attitude target for inner loop
% px4.att_tgt.pitch 
% px4.att_tgt.yaw
% px4.att_tgt.thrust 


%%  Control data: 

% control.tgt.x     : position target
% control.tgt.y
% control.tgt.z
% control.tgt.Vx
% control.tgt.Vy
% control.tgt.Vz
% control.time
 
figure;
ax(1)=subplot(2,3,1);
plot(optitrack.time,-optitrack.z);
hold on;
plot(control.time,-control.tgt.z,'r');
title('Altitude');
grid  on;


ax(2)=subplot(2,3,2);
plot(px4.time,px4.att_tgt.thrust)
hold on;
% plot(control.time,control.tgt.thrust,'r')
title('Thrust (in blue, feedback of px4) ');
grid on;


ax(3)=subplot(2,3,3);
plot(optitrack.time,optitrack.x)
hold on;
plot(control.time,control.tgt.x,'r')
title('X (blue), Xtarget(red)');
grid on;


ax(4)=subplot(2,3,4);
plot(optitrack.time,optitrack.y)
hold on;
plot(control.time,control.tgt.y,'r')
title('Y (blue), Ytarget(red)');
grid on;


ax(5)=subplot(2,3,5);
plot(px4.time,px4.att.pitch);
hold on;
plot(px4.time,px4.att_tgt.pitch,'r');
hold on;
plot(optitrack.time,optitrack.att.pitch,'black');
title('pitch: optitrack (black), target (red)');
grid on;


ax(6)=subplot(2,3,6);
plot(px4.time,px4.att.roll);
hold on;
plot(px4.time,px4.att_tgt.roll,'r');
hold on;
plot(optitrack.time,optitrack.att.roll,'black');
title('roll: optitrack (black), target (red)');
% linkaxes(ax,'x');
grid on;


% figure;
% hold on;
% plot(optitrack.x,optitrack.y)
% plot(control.tgt.x,control.tgt.y,'r')
% title('X Y (blue), X Y target(red)');
% grid on;
% pbaspect([1 1 1]);
% % 
figure
plot3(optitrack.x,optitrack.y,-optitrack.z)
hold  on;
plot3(control.tgt.x,control.tgt.y,-control.tgt.z,'r')
title('Trajectory');
grid on;
rotate3d on;
pbaspect([1 1 1]);



