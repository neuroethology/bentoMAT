function changePlotType(source,~)
gui = guidata(source);

oldPlot = gui.traces.toPlot;
if(strcmpi(oldPlot(1:3),'img'))
    gui.traces.tracesIm.Visible = 'off';
else
    delete(gui.traces.axes.Children(1:end-4));
    gui.traces.traces=[];
end

switch(source.String{source.Value})
    case 'units'
        gui.traces.toPlot = 'rast';
        if(strcmpi(oldPlot,'PCA')||strcmpi(oldPlot,'ctrs'))
            gui.traces.show = true(size(gui.data.rast,1),1);
        end
    case 'd/dt'
        gui.traces.toPlot = 'ddt';
        if(strcmpi(oldPlot,'PCA')||strcmpi(oldPlot,'ctrs'))
            gui.traces.show = true(size(gui.data.rast,1),1);
        end
    case 'PCs'
        gui.traces.toPlot = 'PCA';
        getPCAxes(gui,source);
    case 'clusters'
        gui.traces.toPlot = 'ctrs';
        gui.traces.show = true(10,1);
end

guidata(source,gui);
updatePlot(source,[]);