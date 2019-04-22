function fineAnnotCheck(source,eventdata)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);
t = toc(gui.ctrl.slider.timer);
if(t>0.3)
    gui.ctrl.slider.timer = tic;
    gui.Action = 'dragfineAnnot';
    gui.fineAnnot.clickPt = eventdata.IntersectionPoint(1) + gui.ctrl.slider.Value - gui.fineAnnot.axes.XLim(1) - gui.ctrl.slider.SliderStep(1);
    guidata(gui.h0,gui);
    return;
end

dummy.Source.Tag = 'fineAnnot';
dummy.delta = max(min(gui.ctrl.slider.Value + eventdata.IntersectionPoint(1),gui.ctrl.slider.Max),gui.ctrl.slider.Min) - gui.ctrl.slider.Value;

updatePlot(source,dummy);
