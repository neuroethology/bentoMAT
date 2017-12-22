function toggleAnnot(source,~)
gui = guidata(source);

str = strrep(gui.ctrl.annot.annot.String{gui.ctrl.annot.annot.Value},' ','_');
Ch = strrep(gui.ctrl.annot.ch.String{gui.ctrl.annot.ch.Value},' ','_');

if(source.Value==1)
    if(strcmpi(source.Tag,'add'))
        gui.annot.toggleErase.Value = 0;
    else
        gui.annot.toggleAnnot.Value = 0;
    end
    
    gui.annot.Box.traces.Visible = 'on';
    uistack(gui.annot.Box.traces,'up');
    set(gui.annot.Box.traces,'Ydata',get(gui.traces.axes,'ylim'));
    set(gui.annot.Box.traces,'Xdata',[0 0 0 0]);
    if(strcmpi(source.Tag,'add'))
        set(gui.annot.Box.traces,'FaceColor',gui.annot.cmap.(str)/3+2/3);
    else
        set(gui.annot.Box.traces,'FaceColor',[.8 .8 .8]);
    end
    
    gui.annot.highlightStart = round((gui.ctrl.slider.Value - gui.ctrl.slider.Min + 1/gui.data.annoFR)*gui.data.annoFR);
    guidata(source,gui);
else
    gui.annot.Box.traces.Visible = 'off';
    uistack(gui.annot.Box.traces,'bottom');
    set(gui.annot.Box.traces,'Ydata',[0 0 0 0]);
    set(gui.annot.Box.traces,'FaceColor',[.8 .8 .8])
    
    p1 = gui.annot.highlightStart;
    p2 = round((gui.ctrl.slider.Value - gui.ctrl.slider.Min + 1/gui.data.annoFR)*gui.data.annoFR);
    if(p1<p2)
        inds = p1:p2;
    else
        inds = p2:p1;
    end
    if(isempty(gui.annot.bhv)|~isfield(gui.annot.bhv,str))
        gui.annot.bhv.(str) = false(1,gui.ctrl.slider.Max);
    end
    gui.annot.bhv.(str)(inds) = strcmpi(source.Tag,'add');
    gui.annot.modified = 1;
    gui.annot.highlightStart = [];
    
    updateSliderAnnot(gui);
    guidata(source,gui);
    updatePlot(source,[]);
end