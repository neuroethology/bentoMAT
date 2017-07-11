function changePlotType(source,~)
gui = guidata(source);

oldPlot = gui.toPlot;
switch(source.Value)
    case 1 % raster
        gui.toPlot = 'rast';
        guidata(source,gui);
        updatePlot(source,[]);
    case 2 % PCs
        gui.toPlot = 'PCs';
        getPCAxes(gui,source);
end