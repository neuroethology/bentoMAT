function loadSavedAnnot(source,~)

data = guidata(source);
data.bhv = data.bhvS;
guidata(source,data);
updateSliderAnnot(data);
updatePlot(source,[]);