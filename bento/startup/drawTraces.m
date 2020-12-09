function gui = drawTraces(gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(isfield(gui,'traces'))
    delete(gui.traces.panel);
end
traces.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
traces.axes         = axes('parent',traces.panel,'ytick',[],...
                           'position',[0.1 0.11 0.85 .815]); hold on;
traces.yScale       = 1;
traces.win          = 20;
traces.traces       = [];
traces.tracesIm     = image(ones(1,1,3),'hittest','off','visible','off');
traces.zeroLine     = plot([0 0],get(gca,'ylim'),'k--');
traces.groupLines(1)= plot(get(gca,'ylim'),[0 0],'m','visible','off','hittest','off');
traces.bg           = image(ones(1,1,3),'hittest','off');
uistack(traces.bg,'bottom');
traces.axes.ButtonDownFcn = {@figBoxCheck,'traces'};
traces.clickPt      = 0;
% traces.stim = title('');

xlabel('time (sec)');
axis tight;
xlim(traces.win*[-1 1]);
colormap parula;

gui.traces = traces;