function gui = drawScatter(gui)

if(isfield(gui,'scatter'))
    delete(gui.scatter.panel);
end
scatter.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
scatter.axes         = axes('parent',scatter.panel,'ytick',[]); hold on;
scatter.data         = plot(0,0,'color',[.1 .1 .1]);
scatter.bg           = image(ones(1,1,3),'hittest','off');
uistack(scatter.bg,'bottom');
scatter.axes.ButtonDownFcn = {@figBoxCheck,'scatter'};
scatter.clickPt      = 0;

axis tight;
gui.scatter = scatter;