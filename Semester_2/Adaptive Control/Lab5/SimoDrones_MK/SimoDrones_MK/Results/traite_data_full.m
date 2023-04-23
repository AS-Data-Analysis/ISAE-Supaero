function [ px4,optitrack,control,simulink ] = traite_data_full(file)
%TRAITE_DATA Summary of this function goes here
%   Detailed explanation goes here
load(file)

duree_totale = Te * length(att_eul_optitrack);

% Px4 file
tsimu=[0:Te: Te * (length(att_eul_optitrack)-1)];
px4.time= tsimu;
t1=1;
t2=length(att_eul_optitrack);

var = att_eul_px4(:,1);
px4.att.roll=var(t1:t2);
var = att_eul_px4(:,2);
px4.att.pitch=var(t1:t2);
var = att_eul_px4(:,3);
px4.att.yaw=var(t1:t2);

var = att_tgt_px4(:,1);
px4.att_tgt.roll=var(t1:t2);
var = att_tgt_px4(:,2);
px4.att_tgt.pitch=var(t1:t2);
var = att_tgt_px4(:,3);
px4.att_tgt.yaw=var(t1:t2);
var = att_tgt_px4(:,4);
px4.att_tgt.thrust=var(t1:t2);

var = att_eul_px4(:,4);
px4.att.p=var(t1:t2);
var = att_eul_px4(:,5);
px4.att.q=var(t1:t2);
var = att_eul_px4(:,6);
px4.att.r=var(t1:t2);


% var = imu_acc(:,1);
% px4.att.ax=var(t1:t2);
% var = imu_acc(:,2);
% px4.att.ay=var(t1:t2);
% var = imu_acc(:,3);
% px4.att.az=var(t1:t2);
% var = att_tgt_px4(:,4);
% 
% var = imu_pressure;
% px4.pressure=var(t1:t2);


var = batt_info(:,1);
px4.battery_level=var(t1:t2);


%Optitrack
var = tsimu;
optitrack.time=var(t1:t2)-(t1-1)*Te;
var = att_eul_optitrack(:,1);
optitrack.att.roll=var(t1:t2);
var = att_eul_optitrack(:,2);
optitrack.att.pitch=var(t1:t2);
var = att_eul_optitrack(:,3);
optitrack.att.yaw=var(t1:t2);

var = pos_vel_optitrack(:,1);
optitrack.x=var(t1:t2);
var = pos_vel_optitrack(:,2);
optitrack.y=var(t1:t2);
var = pos_vel_optitrack(:,3);
optitrack.z=var(t1:t2);

var = pos_vel_optitrack(:,4);
optitrack.Vx=var(t1:t2);
var = pos_vel_optitrack(:,5);
optitrack.Vy=var(t1:t2);
var = pos_vel_optitrack(:,6);
optitrack.Vz=var(t1:t2);


%COntrol
var = tsimu;
control.time=var(t1:t2)-(t1-1)*Te;

var = pos_tgt(:,1);
control.tgt.x=var(t1:t2);
var = pos_tgt(:,2);
control.tgt.y=var(t1:t2);
var = pos_tgt(:,3);
control.tgt.z=var(t1:t2);
% var = pos_vel_tgt(:,4);
% control.tgt.vx=var(t1:t2);
% var = pos_vel_tgt(:,5);
% control.tgt.vy=var(t1:t2);
% var = pos_vel_tgt(:,6);
% control.tgt.vz=var(t1:t2);


% var = att_tgt_px4(:,1);
% control.tgt.pitch=var(t1:t2);
% var = att_tgt_px4(:,2);
% control.tgt.roll=var(t1:t2);
% var = att_tgt_px4(:,3);
% control.tgt.yaw=var(t1:t2);
% var = att_tgt_px4(:,4);
% control.tgt.thrust=var(t1:t2);


%simulink
var = tsimu;
simulink.time=var(t1:t2)-(t1-1)*Te;

var = att_tgt_px4(:,1);
simulink.tgt.pitch = var(t1:t2);
var = att_tgt_px4(:,2);
simulink.tgt.roll = var(t1:t2);
var = att_tgt_px4(:,3);
simulink.tgt.yaw = var(t1:t2);
var = att_tgt_px4(:,4);
simulink.tgt.thrust = var(t1:t2);

% simulink.ramp = ramp(t1:t2);
% simulink.ramp_feedback = ramp_feedback(t1:t2);

end

