function clearAction(source,~)

gui = guidata(source);
if(gui.Action~=0)
    if(toc(gui.ctrl.slider.timer)<.3)
        if(~strcmpi(gui.Action,'drag'))
            hSlider = incSliderVal(gui.h0);
        else
            hSlider = setSliderVal(gui.h0);
        end
        updateSlider(gui.h0,hSlider);
        dummy.Source.Tag = 'slider';
        updatePlot(gui.h0,dummy);
        gui.ctrl.slider = hSlider;
    end
end

gui.Action = 0;
guidata(source,gui);