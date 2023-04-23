function modeswitch_button(bh, name_0, name_1, switch_mode)
%MODESWITCH_BUTTON(buttonHandle, name_0, name_1, switch_mode) Switch Simulink button name and internal variable.
%  MODESWITCH_BUTTON  If switch_mode is true, it switches the value of 
%  the internal variable between 0 and 1.
%  The button label is set to the value of the strings name_0 or name_1,
%  depending on the value of the internal variable.
%
%  Internal function, not to be called directly.

% Read internal variable value
mode = get_param([gcb '/mode'],'Value');

% Switch internal value if switch_mode is true
if (switch_mode == true)
    if (mode =='1')
        % set internal variable to 0
        mode ='0';
    else
        % set internal variable to 1
        mode='1';
    end
end

% Set internal variable value
set_param([gcb '/mode'],'Value',mode);

% Set button label
if (mode =='1')
    set_param(bh, 'MaskDisplay', ...
        ['text(0.5,0.8,''' name_1 ''', ''horizontalAlignment'',''center'');'...
        'text(0.5,0.5,''_{_{Switch To\newline ' name_0 '}}'', ''horizontalAlignment'',''center'',''texmode'',''on'');']);
else
    set_param(bh, 'MaskDisplay', ...
        ['text(0.5,0.8,''' name_0 ''', ''horizontalAlignment'',''center'');'...
        'text(0.5,0.5,''_{_{Switch To\newline ' name_1 '}}'', ''horizontalAlignment'',''center'',''texmode'',''on'');']);
end

