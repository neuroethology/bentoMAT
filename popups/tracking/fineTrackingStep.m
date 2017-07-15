function fineTrackingStep(source,~,delta)

h = guidata(source);
gui = h.gui;

v = gui.ctrl.slider.Value + gui.ctrl.slider.Min*delta;
v = max(v,gui.ctrl.slider.Min);
v = min(v,gui.ctrl.slider.Max);

gui.ctrl.slider.Value = v;

guidata(gui.h0,gui);
updateSlider(gui.h0,gui.ctrl.slider);

dummy.Source.Tag = 'slider';
updatePlot(gui.h0,dummy);