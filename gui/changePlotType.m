function changePlotType(source,~)
gui = guidata(source);

oldPlot = gui.traces.toPlot;
switch(source.String{source.Value})
    case 'units'
        gui.traces.toPlot = 'rast';
        if(strcmpi(oldPlot,'PCs'))
            gui.traces.show = true(size(gui.data.rast,1),1);
        end
        guidata(source,gui);
        updatePlot(source,[]);
    case 'PCs'
        gui.traces.toPlot = 'PCs';
        getPCAxes(gui,source);
    case 'd/dt'
        gui.traces.toPlot = 'dt';
        if(strcmpi(oldPlot,'PCs'))
            gui.traces.show = true(size(gui.data.rast,1),1);
        end
        guidata(source,gui);
        updatePlot(source,[]);
end