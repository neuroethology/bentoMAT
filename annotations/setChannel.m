function setChannel(source,~)
%changes which channel is being displayed/annotated on

gui     = guidata(source);
gui     = readoutAnnot(gui);
gui.annot.activeCh = source.String{source.Value};
gui     = transferAnnot(gui,gui.data);

updateSliderAnnot(gui);
updateLegend(gui,1);
guidata(source,gui);
updatePlot(gui.h0,[]);