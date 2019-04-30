function gui = drawfineAnnot(gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(isfield(gui,'fineAnnot'))
    delete(gui.fineAnnot.panel);
end

fineAnnot.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
fineAnnot.axes         = axes('parent',fineAnnot.panel,'ytick',[],...
                              'position',[0.1 0.11 0.85 .815]); hold on;
fineAnnot.win          = 20;
fineAnnot.img          = image();
fineAnnot.img.ButtonDownFcn = {@figBoxCheck,'fineAnnot'};
fineAnnot.zeroLine     = plot([0 0],[0 1],'k--');
fineAnnot.clickPt      = 0;
fineAnnot.txt          = text(0,0,'');

xlim([-1 1]*fineAnnot.win);
ylim([0 1]);

gui.fineAnnot = fineAnnot;