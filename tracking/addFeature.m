function addFeature(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

feat.featNum      = gui.features.menu.Value;
feat.ch           = gui.features.channels.Value;
tag = [gui.features.channels.String{gui.features.channels.Value} ': ' strtrim(gui.features.menu.String(feat.featNum,:))];
if(~isempty(gui.features.feat))
    if(any(strcmpi(tag,{gui.features.feat.tag})))
        return;
    end
end

% create a new feature object
feat.axes         = axes('parent',gui.features.panel,'ytick',[]); hold on;
feat.rmBtn        = uicontrol('parent',gui.features.panel,'Style','pushbutton',...
                        'String','X','units','normalized','Position', [.5 .5 .1 .05],...
                        'callback',{@rmFeature,tag});
feat.thresholdU    = uicontrol('parent',gui.features.panel,'Style','slider','tag','U',...
                        'units','normalized','position',[0 0 .05 .1],...
                        'min',0,'max',1,'value',0.25,...
                        'visible',gui.features.threshOff.Visible,...
                        'callback',{@setFeatThreshold,tag});
feat.thresholdL    = uicontrol('parent',gui.features.panel,'Style','slider','tag','L',...
                        'units','normalized','position',[0 0 .05 .1],...
                        'min',0,'max',1,'value',0.75,...
                        'visible',gui.features.threshOff.Visible,...
                        'callback',{@setFeatThreshold,tag});
feat.threshLineU   = patch([0 0 0 0],[0 0 0 0],[.25 .75 1],'facealpha',.35,'edgecolor','none',...
                        'hittest','off','visible',gui.features.threshOff.Visible);
feat.threshLineL   = patch([0 0 0 0],[0 0 0 0],[.25 .75 1],'facealpha',.35,'edgecolor','none',...
                        'hittest','off','visible',gui.features.threshOff.Visible);
feat.threshValU   = uicontrol('parent',gui.features.panel,'Style','edit','tag','U',...
                        'units','normalized','position',[.5 .5 .1 .05],...
                        'visible',gui.features.threshOff.Visible,...
                        'callback',{@setFeatThreshold,tag});
feat.threshValL   = uicontrol('parent',gui.features.panel,'Style','edit','tag','L',...
                        'units','normalized','position',[.5 .5 .1 .05],...
                        'visible',gui.features.threshOff.Visible,...
                        'callback',{@setFeatThreshold,tag});
feat.thrBound     = 1;

feat.tag          = tag;
feat.label        = text(feat.axes,-gui.features.win*0.975,...
                         max(reshape(gui.data.tracking.features(:,:,feat.featNum),1,[]))*.95,...
                         strrep(tag,'_',' '),'fontsize',14);
                     
feat.trace        = plot(0,0,'color',[.1 .1 .1],'hittest','off');
feat.zeroLine     = plot([0 0],get(gca,'ylim'),'k--','hittest','off');
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

gui = redrawFeaturePlots(gui);

guidata(gui.h0,gui);
updatePlot(gui.h0,[]);
