function setActivePoints(source,~)

h    = guidata(source);
gui  = guidata(h.guifig);

time    = gui.ctrl.slider.Value;
frnum   = floor(time*gui.data.annoFR)+1;

gui.data.tracking.active(frnum:end) = {1:str2num(source.String)};
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);
