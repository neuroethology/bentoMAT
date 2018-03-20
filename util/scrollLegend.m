function scrollLegend(source,~)
gui=guidata(source);

gui.legend.axes.Position(2) = 1-source.Value;