function gui = drawTracker(gui)

if(isfield(gui,'tracker'))
    if(isfield(gui.tracker,'hullPlot'))
        delete(gui.tracker.hullPlot);
    end
    delete(gui.tracker.panel);
end

tracker.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
tracker.axes         = axes('parent',tracker.panel,'ytick',[]); hold on;
tracker.yScale       = 1;
tracker.win          = 20;
tracker.traces       = plot(0,0,'color',[.1 .1 .1]);
tracker.zeroLine     = plot([0 0],get(gca,'ylim'),'k--');

xlabel('time (sec)');
axis tight;
xlim(tracker.win*[-1 1]);


gui.tracker = tracker;