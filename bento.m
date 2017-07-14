fclose all; clear gui;
quitloop = 0;
construct_gui();
while(~quitloop)
    gui = guidata(gui.h0);
    if(gui.Action)
        if(~strcmpi(gui.Action,'drag'))
            hGui = incSliderVal(gui.h0);
        else
            hGui = setSliderVal(gui.h0);
        end
        updateSlider(gui.h0,hGui);
        dummy.Source.Tag = 'slider';
        updatePlot(gui.h0,dummy);
    end
    quitloop = gui.quitbutton;
    drawnow;
end
set(gui.h0,'CloseRequestFcn','closereq');
close(gui.h0);
