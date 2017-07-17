function h = incSliderVal(source)
% this function just implements normal slider behavior (arrow and bar
% clicks).
gui = guidata(source);
h = gui.ctrl.slider;

% check if out-of-range
if(((h.Value + gui.Action)>h.Max)|((h.Value + gui.Action)<h.Min))
    return
end


% check for overshoot
p       = get(0,'PointerLocation');         %click location
marker  = getpixelposition(h.Marker,true);
marker  = gui.h0.Position(1) + marker(1) + marker(3)/2; %marker coordinates
if((gui.h0==gcf) && (sign(p(1) - marker) ~= sign(gui.Action)))
    return;
end

h.Value = h.Value + gui.Action;