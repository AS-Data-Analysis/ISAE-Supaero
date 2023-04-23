save log_temp.mat;
[ bebop,optitrack,command,simulink ] = traite_data_bebop('log_temp');
delete log_temp.mat;

save log.mat drone bebop optitrack command simulink
plot_data_bebop;
