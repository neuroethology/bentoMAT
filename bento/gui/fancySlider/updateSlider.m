function updateSlider(source,h)%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

pos = (h.Value - h.Min)/(h.Max-h.Min)*h.Scale;
h.Marker.Position(1) = pos;

gui.ctrl.slider = h;
guidata(source,gui);