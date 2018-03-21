function gui = drawScatter(gui)

if(isfield(gui,'scatter'))
    delete(gui.scatter.panel);
end
scatter.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
scatter.axes         = axes('parent',scatter.panel,'ytick',[],'xtick',[]); hold on;
scatter.alldata      = plot(0,0,'color',[.85 .85 .85]);
scatter.data         = plot(0,0,'color',[.65 .65 .65]);
scatter.tail         = plot(0,0,'k','linewidth',2);
scatter.currentFrame = plot(0,0,'ko','markerfacecolor','k','markersize',10);

axis tight;
gui.scatter = scatter;