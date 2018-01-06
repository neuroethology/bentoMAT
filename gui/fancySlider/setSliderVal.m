function h = setSliderVal(source)
% this function lets the user click and drag the slider.
gui    = guidata(source);

p       = get(0,'PointerLocation');         % absolute location of the click
figPos  = getpixelposition(source);         % absolute location of the figure

h = gui.ctrl.slider;
switch gui.Action(5:end)
    case 'slider'
        obj     = gui.ctrl.slider.Ctr;
        scale   = (gui.ctrl.slider.Max - gui.ctrl.slider.Min);
        offset  = gui.ctrl.slider.Min - gui.ctrl.slider.Marker.Position(3)/2;
    case 'fineAnnot'
        obj     = gui.fineAnnot.axes;
        scale   = -(obj.XLim(2) - obj.XLim(1));
        offset  = gui.fineAnnot.clickPt(1);
end

dragTo    = getpixelposition(obj,true);     % location of the relevant box within the figure
dragTo(1) = dragTo(1) + figPos(1);
dragTo    = (p(1) - dragTo(1))/dragTo(3);

h.Value = dragTo*scale + offset;
h.Value = min(max(h.Value,h.Min),h.Max);