% function launchFastAnnotator(source,~)
% gui  = guidata(source);
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



h.guifig = gui.h0;
h.fig = figure('dockcontrols','off','menubar','none',...
    'Tag','Tracking','name','Annotations','NumberTitle','off',...
    'WindowButtonUpFcn',@clearActionFromPopup);
h.Action=[];
gui.browser = h.fig;
p = get(h.fig,'Position');
set(h.fig,'Position',[p(1:2)+[160 0] 225 450]);

bhv = fieldnames(gui.annot.bhv);
bhv = strrep(bhv,'_',' ');
for i = 1:length(bhv)
h.bhv(i) = uicontrol('Style','togglebutton','String',bhv{i},...
            'units','normalized','Position',[.05 .11+.07*i .9 .06],'fontsize',11);
end

% buttons for easier frame-by-frame advance
uicontrol('Style','pushbutton','String',char(171),...
            'units','normalized','Position', [.065 .1 .2 .075],'fontsize',11,...
            'Enable', 'inactive','ButtonDownFcn',{@fineTrackingStep, -1});
uicontrol('Style','pushbutton','String',char(9664),...
            'units','normalized','Position', [.29 .1 .2 .075],'fontsize',11,...
            'Enable', 'inactive','ButtonDownFcn',{@fineTrackingStep, -1/gui.data.io.movie.FR});
uicontrol('Style','pushbutton','String',char(9654),...
            'units','normalized','Position', [.515 .1 .2 .075],'fontsize',11,...
            'Enable', 'inactive','ButtonDownFcn',{@fineTrackingStep, 1/gui.data.io.movie.FR});
uicontrol('Style','pushbutton','String',char(187),...
            'units','normalized','Position', [.74 .1 .2 .075],'fontsize',11,...
            'Enable', 'inactive','ButtonDownFcn',{@fineTrackingStep, 1});
        

load('icons.mat');
annot.toggleErase = uicontrol('Style','togglebutton','CData',imgs.f2,'units','normalized',...
               'Tag','remove','position',[.3 .015 .18 .075],'tooltip','Erase annotation','Callback',@toggleAnnot);
annot.save        = uicontrol('Style','pushbutton','CData',imgs.f3,'units','normalized',...
               'position',[.5 .015 .18 .075],'tooltip','Save annotations','callback',@quickSave);

        
