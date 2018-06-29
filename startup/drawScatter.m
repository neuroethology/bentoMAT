function gui = drawScatter(gui)

if(isfield(gui,'scatter'))
    delete(gui.scatter.panel);
end
scatter.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
scatter.axes         = axes('parent',scatter.panel,'ytick',[],'xtick',[]); hold on;
scatter.alldata      = plot(0,0,'color',[.95 .95 .95]);
scatter.data         = plot(0,0,'color',[.85 .85 .85]);
scatter.tail         = surface([0;0],[0;0],[0;0],zeros(2,1,3),'facecol','no','edgecol','interp','linew',2);
scatter.currentFrame = plot(0,0,'ko','markerfacecolor','k','markersize',10);

axis tight;
gui.scatter = scatter;