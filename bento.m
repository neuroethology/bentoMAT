fclose all; clear gui;
quitloop = 0;
construct_gui();

while(~quitloop)
    gui = guidata(gui.h0);
    if(any(gui.Action))
        test = toc(gui.ctrl.slider.timer);
        if(test>0.2)
            if(~strcmpi(gui.Action,'drag'))
                hSlider = incSliderVal(gui.h0);
            else
                hSlider = setSliderVal(gui.h0);
            end
            updateSlider(gui.h0,hSlider);
            dummy.Source.Tag = 'slider';
            updatePlot(gui.h0,dummy);
        end
    end
    quitloop = gui.quitbutton;
    drawnow;
end
set(gui.h0,'CloseRequestFcn','closereq');
close(gui.h0);
