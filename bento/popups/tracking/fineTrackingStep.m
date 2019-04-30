function fineTrackingStep(source,~,delta)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



h = guidata(source);
gui = guidata(h.guifig);

gui.ctrl.slider.timer = tic;
gui.Action = [delta 0];
h.Action   = [delta 0];

guidata(gui.h0,gui);
guidata(source,h);
updateSlider(gui.h0,gui.ctrl.slider);

dummy.Source.Tag = 'slider';
updatePlot(gui.h0,dummy);