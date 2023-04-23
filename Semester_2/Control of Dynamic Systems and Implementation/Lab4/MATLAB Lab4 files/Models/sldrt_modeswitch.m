function sldrt_modeswitch(bh, switch_mode)
%SLDRTEXCB_MODESWITCH(buttonHandle, switch_mode) Switch Simulink Desktop Real-Time example mode.
%  SLDRTEXCB_MODESWITCH switches a Simulink Desktop Real-Time example
%  model between normal and external mode.
%
%  Internal function, not to be called directly.

%   Copyright 1994-2015 The MathWorks, Inc.

% Get handle to model
mh = bdroot(bh);

name_0 = 'Simulation Mode';
name_1 = 'Experiment Mode';

% Set button label
modeswitch_button(bh, name_0, name_1, false)

% Get simulation status
status = get_param(gcs,'SimulationStatus');

% Declare the variant associated to simulation and experiment mode
assignin('base', 'SIMULATION_MODE', Simulink.Variant('mode_id==0'));
assignin('base', 'EXPERIMENT_MODE', Simulink.Variant('mode_id==1'));

if (strcmp(status,'stopped'))
    modeswitch_button(bh, name_0, name_1, switch_mode)
    
    % Get internal variable value
    mode = get_param([gcb '/mode'],'Value');
    
    if (mode =='1')
        % set simulation mode to External
        set_param(mh, 'SimulationMode', 'external')
        
        assignin('base', 'mode_id', 1);
        
        % Set simulation time to inf to force a manual stop
        set_param(mh, 'StopTime', 'inf');
        
        %         % set fixed-step solver for sldrtex_vdp
        %         if strcmpi(get_param(mh, 'Name'), 'sldrtex_vdp')
        %             set_param(mh, 'SolverType', 'Fixed-step');
        %         end
        
    else
        % set simulation mode to Normal
        set_param(mh, 'SimulationMode', 'normal')
        
        assignin('base', 'mode_id', 0);
        
        % Set simulation time to inf to force a manual stop
        set_param(mh, 'StopTime', '50');
        
        %         % set variable-step solver for sldrtex_vdp
        %         if strcmpi(get_param(mh, 'Name'), 'sldrtex_vdp')
        %             set_param(mh, 'SolverType', 'Variable-step');
        %         end
        
    end
    
else
    errordlg('The system must be stopped to change between Experiment and Simulation mode')
end




