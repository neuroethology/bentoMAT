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

uicontrol('parent',features.panel,'Style','text','horizontalalign','right',...
                        'String','Channel:','units','normalized','Position', [.05 0.01 .175 0.05]);
features.channels     = uicontrol('parent',features.panel,'Style','popupmenu',...
                        'String',{''},'units','normalized','Position', [.225 0.015 .1 0.05]);
features.menu         = uicontrol('parent',features.panel,'Style','popupmenu',...
                        'String',{''},'units','normalized','Position', [.375 0.015 .365 0.05]);
uicontrol('parent',features.panel,'Style','pushbutton',...
                        'String','Add','units','normalized','Position', [.75 0.02 .1 .05],...
                        'Callback',@addFeature);


gui.features = features;