function get_Data(src,event)
    s=event.Data;
    assignin('base','s',s);
    assignin('base','ready',1);
end