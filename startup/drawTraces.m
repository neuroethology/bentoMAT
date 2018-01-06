function gui = drawTraces(gui)

if(isfield(gui,'traces'))
    delete(gui.traces.panel);
end
traces.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
traces.axes         = axes('parent',traces.panel,'ytick',[]); hold on;
traces.yScale       = 50;
traces.win          = 20;
traces.traces       = plot(0,0,'color',[.1 .1 .1]);
traces.zeroLine     = plot([0 0],get(gca,'ylim'),'k--');
traces.bg           = image(ones(1,1,3),'hittest','off');
uistack(traces.bg,'bottom');
traces.axes.ButtonDownFcn = {@figBoxCheck,'traces'};
traces.clickPt      = 0;

xlabel('time (sec)');
axis tight;
xlim(traces.win*[-1 1]);

gui.traces = traces;