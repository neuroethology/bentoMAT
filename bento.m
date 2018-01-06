fclose all; clear gui;
construct_gui();
quitloop = 0;

while(~quitloop)
    gui = guidata(gui.h0);
    if(any(gui.Action))
        test = toc(gui.ctrl.slider.timer);
        if(test>0.1)
            if(~isempty(strfind(gui.Action,'drag')))
                hSlider = setSliderVal(gui.h0);
            else
                hSlider = incSliderVal(gui.h0);
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
