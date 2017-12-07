function changePlotType(source,~)
gui = guidata(source);

oldPlot = gui.traces.toPlot;
switch(source.Value)
    case 1 % raster
        gui.traces.toPlot = 'rast';
        guidata(source,gui);
        updatePlot(source,[]);
    case 2 % PCs
        gui.traces.toPlot = 'PCs';
        getPCAxes(gui,source);
end