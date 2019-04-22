function h = setSliderVal(source)
% this function lets the user click and drag the slider.
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui     = guidata(source);
h       = gui.ctrl.slider;

p       = get(0,'PointerLocation');         % absolute location of the click
figPos  = getpixelposition(source);         % absolute location of the figure

parent = gui.Action(5:end);
if(strcmpi(parent,'slider'))
    obj     = gui.ctrl.slider.Ctr;
    scale   = (gui.ctrl.slider.Max - gui.ctrl.slider.Min);
    offset  = gui.ctrl.slider.Min - gui.ctrl.slider.Marker.Position(3)/2;
else
    if(~strcmpi(parent,'features'))
        obj = gui.(parent).axes;
    else
        obj = gui.features.feat(1).axes;
    end
    scale   = -(obj.XLim(2) - obj.XLim(1));
    offset  = gui.(parent).clickPt(1);
end

dragTo    = getpixelposition(obj,true);     % location of the relevant box within the figure
dragTo(1) = dragTo(1) + figPos(1);
dragTo    = (p(1) - dragTo(1))/dragTo(3);

h.Value = dragTo*scale + offset;
h.Value = min(max(h.Value,h.Min),h.Max);