function evalKeyDown(source,eventdata)

gui=guidata(source);

switch eventdata.Key
    case 'rightarrow'
        if(any(gui.Action~=[gui.ctrl.slider.SliderStep(1) 0]))
            gui.ctrl.slider.timer = tic;
        end
        gui.Action = [gui.ctrl.slider.SliderStep(1) 0];
    case 'leftarrow'
        if(any(gui.Action~=[-gui.ctrl.slider.SliderStep(1) 0]))
            gui.ctrl.slider.timer = tic;
        end
        gui.Action = [-gui.ctrl.slider.SliderStep(1) 0];
    case 'shift'
        gui.Keys.Shift = 1;
    case 'control'
        gui.Keys.Ctrl = 1;
end

guidata(gui.h0,gui);