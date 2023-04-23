function [ bebop,optitrack,control,simulink ] = traite_data_bebop(file)
%TRAITE_DATA Summary of this function goes here
%   Detailed explanation goes here
load(file)

duree_totale = Te * length(att_eul_optitrack);

%%%%%%%%%%%%%%%%%%%%%%%%%
%       bebop data      %
%%%%%%%%%%%%%%%%%%%%%%%%%

tsimu=[0:Te: Te * (length(att_eul_optitrack)-1)];
bebop.time= tsimu;
t1=1;
t2=length(att_eul_optitrack);

var = att_eul_feedback_bebop(:,1);
bebop.att.roll=var(t1:t2);
var = att_eul_feedback_bebop(:,2);
bebop.att.pitch=var(t1:t2);
var = att_eul_feedback_bebop(:,3);
bebop.att.yaw=var(t1:t2);

var = vel_optical_flow(:,1);
bebop.Vx= var(t1:t2);
var = vel_optical_flow(:,2);
bebop.Vy= var(t1:t2);
var = vel_optical_flow(:,3);
bebop.Vz= var(t1:t2);
 
var = altitude;
bebop.z=-var(t1:t2);

% State of charge of battery
bebop.soc=Soc(t1:t2);

% Internal state of bebop
bebop.state=bebop_state(t1:t2);

var = control_tgt_bebop(:,1);
bebop.target.roll=var(t1:t2);
var = control_tgt_bebop(:,2);
bebop.target.pitch=var(t1:t2);
var = control_tgt_bebop(:,3);
bebop.target.yawrate=var(t1:t2);
var = control_tgt_bebop(:,4);
bebop.target.Vz=var(t1:t2);
var = control_tgt_bebop(:,5);
bebop.target.takeoff=var(t1:t2);
var = control_tgt_bebop(:,6);
bebop.target.land=var(t1:t2);

var = att_eul_feedback_bebop(:,4);
bebop.att.p=var(t1:t2);
var = att_eul_feedback_bebop(:,5);
bebop.att.q=var(t1:t2);
var = att_eul_feedback_bebop(:,6);
bebop.att.r=var(t1:t2);


%%%%%%%%%%%%%%%%%%%%%%%%%
%        Optitrack      %
%%%%%%%%%%%%%%%%%%%%%%%%%
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


%%%%%%%%%%%%%%%%%%%%%%%%%
%        Control        %
%%%%%%%%%%%%%%%%%%%%%%%%%
var = tsimu;
control.time=var(t1:t2)-(t1-1)*Te;

var = pos_tgt(:,1);
control.tgt.x=var(t1:t2);
var = pos_tgt(:,2);
control.tgt.y=var(t1:t2);
var = pos_tgt(:,3);
control.tgt.z=var(t1:t2);



%%%%%%%%%%%%%%%%%%%%%%%%%
%        Simulink       %
%%%%%%%%%%%%%%%%%%%%%%%%%
var = tsimu;
simulink.time=var(t1:t2)-(t1-1)*Te;


end

