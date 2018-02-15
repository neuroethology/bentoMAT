function addFeature(source,~)
gui = guidata(source);

feat.featNum      = gui.features.menu.Value;
tag = strtrim(gui.features.menu.String(feat.featNum,:));
if(~isempty(gui.features.feat))
    if(any(strcmpi(tag,{gui.features.feat.tag})))
        return;
    end
end

% create a new feature object
feat.axes         = axes('parent',gui.features.panel,'ytick',[]); hold on;
feat.rmBtn        = uicontrol('parent',gui.features.panel,'Style','pushbutton',...
                        'String','X','units','normalized','Position', [.5 .5 .1 .05]);
feat.tag          = tag;
feat.label        = text(feat.axes,-gui.features.win*0.975,...
                         max(gui.data.tracking.features(:,feat.featNum))*.975,...
                         strrep(tag,'_',' '),'fontsize',14);
                     
feat.trace        = plot(0,0,'color',[.1 .1 .1]);
feat.zeroLine     = plot([0 0],get(gca,'ylim'),'k--');
feat.bg           = image(ones(1,1,3),'hittest','off');
uistack(feat.bg,'bottom');
feat.axes.ButtonDownFcn = {@figBoxCheck,'features'};
xlim(gui.features.win*[-1 1]);


%add this feature to the list
if(isempty(gui.features.feat))
    gui.features.feat        = feat;
else
    gui.features.feat(end+1) = feat;
end
gui.features.feat(end).rmBtn.Callback = {@rmFeature,tag};

gui = redrawFeaturePlots(gui);

guidata(gui.h0,gui);
updatePlot(gui.h0,[]);
