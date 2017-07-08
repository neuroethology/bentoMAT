function updateSliderAnnot(gui)

time 	= round((gui.data.annoTime(end)-gui.data.annoTime(1))*gui.data.annoFR);
img     = makeBhvImage(gui.annot.bhv,gui.annot.cmap,[],time,gui.annot.show);

bgsmall = displayImage(img,gui.ctrl.slider.Pos(3)*gui.h0.Position(3)*5,1);
set(gui.ctrl.slider.bg,'cdata',bgsmall);