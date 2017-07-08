function updateSlider(source,h)
gui = guidata(source);

pos = (h.Value - h.Min)/(h.Max-h.Min)*h.Scale;
h.Marker.Position(1) = pos;

gui.ctrl.slider = h;
guidata(source,gui);