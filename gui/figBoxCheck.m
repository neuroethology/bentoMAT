function figBoxCheck(source,eventdata,boxID)
gui = guidata(source);
t = toc(gui.ctrl.slider.timer);
if(t>0.25)
    gui.ctrl.slider.timer = tic;
    gui.Action = ['drag' boxID];
    gui.(boxID).clickPt = eventdata.IntersectionPoint(1) + gui.ctrl.slider.Value - gui.(boxID).axes.XLim(1) - gui.ctrl.slider.SliderStep(1);
    guidata(gui.h0,gui);
    return;
end

dummy.Source.Tag = 'doubleClick';
dummy.delta = max(min(gui.ctrl.slider.Value + eventdata.IntersectionPoint(1),gui.ctrl.slider.Max),gui.ctrl.slider.Min) - gui.ctrl.slider.Value;

updatePlot(source,dummy);
