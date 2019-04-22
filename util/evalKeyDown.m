function evalKeyDown(source,eventdata)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui=guidata(source);

switch eventdata.Key
    case 'rightarrow'
        if(any(gui.Action~=[gui.ctrl.slider.SliderStep(1) 0]))
            gui.ctrl.slider.timer = tic;
        end
        if(gui.Keys.Shift)
            gui.Action = [gui.ctrl.slider.SliderStep(2) 0];
        else
            gui.Action = [gui.ctrl.slider.SliderStep(1) 0];
        end
        
    case 'leftarrow'
        if(any(gui.Action~=[-gui.ctrl.slider.SliderStep(1) 0]))
            gui.ctrl.slider.timer = tic;
        end
        if(gui.Keys.Shift)
            gui.Action = [gui.ctrl.slider.SliderStep(2) 0];
        else
            gui.Action = [-gui.ctrl.slider.SliderStep(1) 0];
        end
        
    case 'shift'
        gui.Keys.Shift = 1;
        if(any(gui.Action))
            gui.Action(1) = gui.ctrl.slider.SliderStep(2);
        end
        
    case 'control'
        gui.Keys.Ctrl = 1;
end

guidata(gui.h0,gui);