function gui = drawfineAnnot(gui)

if(isfield(gui,'fineAnnot'))
    delete(gui.fineAnnot.panel);
end

fineAnnot.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
fineAnnot.axes         = axes('parent',fineAnnot.panel,'ytick',[]); hold on;
fineAnnot.win          = 20;
fineAnnot.img          = image();
fineAnnot.zeroLine     = plot([0 0],[0 1],'k--');

axis tight;
ylim([0 1]);

gui.fineAnnot = fineAnnot;