function evalKeyUp(source,eventdata)

gui=guidata(source);
% if(isempty(gui.annot.activeCh))
%     return
% end

gui.ctrl.slider.timer = tic;
if(strcmpi(eventdata.Key,'space'))
    if(~gui.Action)
        gui.Action = gui.ctrl.slider.SliderStep(1);
    else
        gui.Action = 0;
    end
end
guidata(gui.h0,gui);