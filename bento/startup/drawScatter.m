function gui = drawScatter(gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(isfield(gui,'scatter'))
    delete(gui.scatter.panel);
end
scatter.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
scatter.axes         = axes('parent',scatter.panel,'ytick',[],'xtick',[]); hold on;
scatter.alldata      = plot(0,0,'color',[.95 .95 .95]);
scatter.data         = plot(0,0,'color',[.85 .85 .85]);
scatter.tail         = surface(0,0,0,zeros(1,1,3),'facecol','no','edgecol','interp','linew',2);
scatter.currentFrame = plot(0,0,'ko','markerfacecolor','k','markersize',10);
scatter.hideOther    = uicontrol('parent',scatter.panel,'style','checkbox','string','Omit unannotated frames',...
        'units','normalized','position',[.15 .025 .7 .055],'callback',@updatePlot);

axis tight;
gui.scatter = scatter;