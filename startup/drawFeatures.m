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

features.channels     = uicontrol('parent',features.panel,'Style','popupmenu',...
                        'String',{''},'units','normalized','Position', [.05 0.015 .125 0.05]);
features.menu         = uicontrol('parent',features.panel,'Style','popupmenu',...
                        'String',{''},'units','normalized','Position', [.175 0.015 .34 0.05]);
uicontrol('parent',features.panel,'Style','pushbutton','String','Add',...
                        'units','normalized','Position', [.525 0.03 .075 .04],...
                        'Callback',@addFeature);
                    
% for thresholding features and making new annotations
features.threshOn = uicontrol('parent',features.panel,'Style','pushbutton','String','Edit Thresholds',...
                        'units','normalized','Position', [.675 0.03 .25 .04],...
                        'Callback',{@toggleFeatThresholds,1});
                    
% hidden buttons that are shown while we're working with feature thresholds
features.threshOff = uicontrol('parent',features.panel,'Style','pushbutton','String','Cancel',...
                        'units','normalized','Position', [.8 0.03 .15 .04],...
                        'Callback',{@toggleFeatThresholds,0},'visible','off');
features.threshSave = uicontrol('parent',features.panel,'Style','pushbutton','String','Save',...
                        'units','normalized','Position', [.645 0.03 .15 .04],...
                        'Callback',@saveFeatThresholds,'visible','off');

gui.features = features;