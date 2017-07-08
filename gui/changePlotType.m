function changePlotType(source,~)
gui = guidata(source);

oldPlot = gui.toPlot;
switch(source.Value)
    case 1 % raster
        gui.toPlot = 'rast';
        gui.gui.pickUnits.String = 'Select units';
    case 2 % PCs
        gui.toPlot = 'PCs';
        gui.gui.pickUnits.String = 'Select PCs';
end

if(~strcmpi(oldPlot,gui.toPlot))
    delete(gui.h{4});
    gui.show   = ones(size(gui.(gui.toPlot),1),1);
    gui.bump   = nanstd(gui.(gui.toPlot)(:))*3;
end

guidata(source,gui);
updatePlot(source,[]);