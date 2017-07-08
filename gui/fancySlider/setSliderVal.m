function h = setSliderVal(source)
% this function lets the user click and drag the slider.
gui    = guidata(source);
h       = gui.ctrl.slider;

p       = get(0,'PointerLocation');         % absolute location of the click
figPos  = getpixelposition(source);         % absolute location of the figure
boxPos  = getpixelposition(h.Ctr,true);     % location of the slider box within the figure
boxPos(1) = boxPos(1) + figPos(1);

barPos = (p(1) - boxPos(1))/boxPos(3);
correctForMarker = -h.Marker.Position(3)*1/2;
h.Value = barPos*(h.Max-h.Min) + h.Min + correctForMarker;

h.Value = min(max(h.Value,h.Min),h.Max);