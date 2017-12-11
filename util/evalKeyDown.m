function evalKeyDown(source,eventdata)

gui=guidata(source);

switch eventdata.Key
    case 'pagedown'
        if(any(gui.Action~=[gui.ctrl.slider.SliderStep(2) 0]))
            gui.ctrl.slider.timer = tic;
        end
        gui.Action = [gui.ctrl.slider.SliderStep(2) 0];
    case 'rightarrow'
        if(any(gui.Action~=[gui.ctrl.slider.SliderStep(1) 0]))
            gui.ctrl.slider.timer = tic;
        end
        gui.Action = [gui.ctrl.slider.SliderStep(1) 0];
    case 'pageup'
        if(any(gui.Action~=[-gui.ctrl.slider.SliderStep(2) 0]))
            gui.ctrl.slider.timer = tic;
        end
        gui.Action = [-gui.ctrl.slider.SliderStep(2) 0];
    case 'leftarrow'
        if(any(gui.Action~=[-gui.ctrl.slider.SliderStep(1) 0]))
            gui.ctrl.slider.timer = tic;
        end
        gui.Action = [-gui.ctrl.slider.SliderStep(1) 0];
end

guidata(gui.h0,gui);