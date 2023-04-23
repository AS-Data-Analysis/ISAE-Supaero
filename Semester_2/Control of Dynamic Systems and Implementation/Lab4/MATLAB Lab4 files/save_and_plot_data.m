%Save and plot data after simulation

out = logsout2struct(logsout);
save('log.mat','out');

%Plot data
%Altitude
figure;
ax(1)=subplot(331);
stairs(out.optitrack.z.time,out.optitrack.z.data);
hold on;
stairs(out.bebop_sensors.altitude.time,-out.bebop_sensors.altitude.data);
stairs(out.pos_tgt.time,out.pos_tgt.data(:,3));
legend('altitude optitrack','-1*altitude bebop','altitude target');
%X
ax(2)=subplot(332);
stairs(out.optitrack.x.time,out.optitrack.x.data);
hold on;
stairs(out.pos_tgt.time,out.pos_tgt.data(:,1));
legend('x optitrack','x target');
%Y
ax(3)=subplot(333);
stairs(out.optitrack.y.time,out.optitrack.y.data);
hold on;
stairs(out.pos_tgt.time,out.pos_tgt.data(:,2));
legend('y optitrack','y target');
%VZ
ax(4)=subplot(334);
stairs(out.optitrack.Vz.time,out.optitrack.Vz.data);
hold on;
stairs(out.bebop_sensors.optical_flow_Vz.time,out.bebop_sensors.optical_flow_Vz.data);
legend('Vz optitrack','Vz bebop');
%VX
ax(5)=subplot(335);
stairs(out.optitrack.Vx.time,out.optitrack.Vx.data);
hold on;
stairs(out.bebop_sensors.optical_flow_Vx.time,out.bebop_sensors.optical_flow_Vx.data);
legend('Vx optitrack','Vx bebop');
ax(6)=subplot(336);
stairs(out.optitrack.Vy.time,out.optitrack.Vy.data);
hold on;
stairs(out.bebop_sensors.optical_flow_Vy.time,out.bebop_sensors.optical_flow_Vy.data);
legend('Vy optitrack','Vy bebop');
ax(9)=subplot(339);
stairs(out.optitrack.roll.time,out.optitrack.roll.data);
hold on;
stairs(out.bebop_sensors.roll.time,out.bebop_sensors.roll.data);
legend('roll optitrack','roll bebop');
ax(8)=subplot(338);
stairs(out.optitrack.pitch.time,out.optitrack.pitch.data);
hold on;
stairs(out.bebop_sensors.pitch.time,out.bebop_sensors.pitch.data);
legend('pitch optitrack','pitch bebop');
linkaxes(ax,'x');

%Trajectoire 3D
figure;
plot3(out.optitrack.x.data,out.optitrack.y.data,out.optitrack.z.data);
xlabel('x');ylabel('y');zlabel('z');

function out = logsout2struct(in)
% Reformate un dataset simulink en structure

%-------------------------------------------------------------------------------
% (c)Institut Superieur de l'Aeronautique et de l'Espace
%    Laurent Alloza
%    02-Mar-2020
%-------------------------------------------------------------------------------
validateattributes(in,{'Simulink.SimulationData.Dataset'},{'nonempty'});
elements = getElementNames(in);
for n=1:length(elements)
    out.(elements{n})=reformat(in{n}.Values);
end
end

function out = reformat(Values)
    validateattributes(Values,{'timeseries','struct'},{'nonempty'});
    switch class(Values)
        case 'timeseries'
            out.time=Values.Time;
            out.data=Values.Data;
        case 'struct'
            elements = fieldnames(Values);
            for n=1:length(elements)
                out.(elements{n})=reformat(Values.(elements{n}));
            end
    end
end