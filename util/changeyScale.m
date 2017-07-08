function changeyScale(source,~,sc)
gui = guidata(source);

gui.traces.yScale = gui.traces.yScale * sc;
guidata(source,gui);

updatePlot(source,[]);