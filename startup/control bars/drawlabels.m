function labels = drawlabels(gui,row,scale,nRows)

labels.panel = uipanel('parent',gui.ctrl.panel,...
        'position',[0.01 (row-.5)/(nRows+1) 0.98 scale/(nRows+1)],'bordertype','none','visible','off');