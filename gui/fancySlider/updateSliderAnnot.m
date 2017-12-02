function updateSliderAnnot(gui)

if(~isempty(gui.data.annoTime))
    time 	= round((gui.data.annoTime(end)-gui.data.annoTime(1))*gui.data.annoFR);
elseif(gui.enabled.traces)
    time = round(gui.data.CaTime(end) - gui.data.CaTime(1)*gui.data.CaFR);
end

inds = find((gui.data.annoTime>=gui.ctrl.slider.Min) & (gui.data.annoTime<=gui.ctrl.slider.Max));
img     = makeBhvImage(gui.annot.bhv,gui.annot.cmap,inds,time,gui.annot.show);

bgsmall = displayImage(img,gui.ctrl.slider.Pos(3)*gui.h0.Position(3)*5,1);
set(gui.ctrl.slider.bg,'cdata',bgsmall);