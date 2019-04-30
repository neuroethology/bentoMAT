function setActivePoints(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



h    = guidata(source);
gui  = guidata(h.guifig);

time    = gui.ctrl.slider.Value;
frnum   = floor(time*gui.data.annoFR)+1;

gui.data.tracking.active(frnum:end) = {1:str2num(source.String)};
gui.data.tracking.inactive(frnum:end) = {str2num(source.String)+1:1e3}; %gonna... assume you never track over 1e3 things.
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);
