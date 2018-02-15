function gui = drawFeatures(gui)

if(isfield(gui,'tracker'))
    if(isfield(gui.features,'hullPlot'))
        delete(gui.features.hullPlot);
    end
    delete(gui.features.panel);
end

features.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
features.win          = 20;
features.clickPt      = 0;
features.axes.XLim    = [-20 20];
features.feat         = [];

features.menu         = uicontrol('parent',features.panel,'Style','popupmenu',...
                        'String',{''},'units','normalized','Position', [.275 0.025 .325 0.05]);
uicontrol('parent',features.panel,'Style','pushbutton',...
                        'String','Add','units','normalized','Position', [.615 0.03 .1 .05],...
                        'Callback',@addFeature);


gui.features = features;