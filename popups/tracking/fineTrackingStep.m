function fineTrackingStep(source,~,delta)

h = guidata(source);
gui = guidata(h.guifig);

gui.ctrl.slider.timer = tic;
gui.Action = delta;
h.Action   = delta;

guidata(gui.h0,gui);
guidata(source,h);
updateSlider(gui.h0,gui.ctrl.slider);

dummy.Source.Tag = 'slider';
updatePlot(gui.h0,dummy);