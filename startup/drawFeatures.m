function gui = drawFeatures(gui)

if(isfield(gui,'tracker'))
    if(isfield(gui.features,'hullPlot'))
        delete(gui.features.hullPlot);
    end
    delete(gui.features.panel);
end

features.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
features.axes         = axes('parent',features.panel,'ytick',[]); hold on;
features.yScale       = 1;
features.win          = 20;
features.traces       = plot(0,0,'color',[.1 .1 .1]);
features.zeroLine     = plot([0 0],get(gca,'ylim'),'k--');

xlabel('time (sec)');
axis tight;
xlim(features.win*[-1 1]);


gui.features = features;