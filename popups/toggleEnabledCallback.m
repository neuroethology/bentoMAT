function toggleEnabledCallback(source,~)

h0 = guidata(source);
gui = guidata(h0);
gui.enabled.(strtrim(source.String))(2) = source.Value;

if(gui.enabled.annot(2))
    gui.ctrl.annot.panel.Visible = 'on';
else
    gui.ctrl.annot.panel.Visible = 'off';
end
updateSliderAnnot(gui);
gui = redrawPanels(gui);
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);