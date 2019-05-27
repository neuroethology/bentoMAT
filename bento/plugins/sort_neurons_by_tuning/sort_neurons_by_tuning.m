function Sort_neurons_by_tuning(source)
% ask the user which trials and conditions to use for CP analysis.
% processCP does the real work, with help from doCP.

%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);
m       = gui.data.info.mouse;
sess    = gui.data.info.session;
use     = gui.allPopulated(:,1)==m & gui.allPopulated(:,2)==str2double(strrep(sess,'session',''));
trList  = gui.allPopulated(use,3);
bhvList = [fieldnames(gui.annot.bhv); {'no label'}];

stringList = {};
for tr = trList'
    stringList{end+1} = [' ' num2str(tr) ') ' gui.allData(m).(sess)(tr).stim];
end

h.fig = figure('dockcontrols','off','menubar','none',...
    'Tag','CP Setup','name','sorting cells by behavior Choice Probability','NumberTitle','off');
gui.browser = h.fig;
p = get(h.fig,'Position');
set(h.fig,'Position',[p(1:2)-[160 0] 740 360]);


uicontrol('Style','text','horizontalalign','left',...
            'String','Select conditions across which to compare cell activity:',...
            'Units','normalized',...
            'Position',[.0125 .915 1 .05],...
            'fontsize',11);
uicontrol('Style','text','horizontalalign','center',...
            'String','Condition 1',...
            'Units','normalized',...
            'Position',[.025 .835 .225 .05],...
            'fontsize',9);
h.bhv1 = uicontrol('Style','listbox',...
            'Max',length(bhvList),...
            'String',bhvList,'Value',[],...
            'Units','normalized',...
            'Position',[.025 .26 .225 .57]);
h.ch1 = uicontrol('style','popupmenu',...
            'String',gui.annot.channels',...
            'units','normalized',...
            'position',[.025 .14 .225 .1]);
uicontrol('Style','text','horizontalalign','center',...
            'String','in trials...',...
            'Units','normalized',...
            'Position',[.26 .835 .225 .05],...
            'fontsize',9);
h.tr1 = uicontrol('Style','listbox',...
            'Max',length(bhvList),...
            'String',stringList,'Value',[],...
            'Units','normalized',...
            'Position',[.26 .18 .225 .65]);
        
uicontrol('Style','text','horizontalalign','center',...
            'String','Condition 2',...
            'Units','normalized',...
            'Position',[.515 .835 .225 .05],...
            'fontsize',9);
h.bhv2 = uicontrol('Style','listbox',...
            'Max',length(bhvList),...
            'String',bhvList,'Value',[],...
            'Units','normalized',...
            'Position',[.515 .26 .225 .57]);
h.ch2 = uicontrol('style','popupmenu',...
            'String',gui.annot.channels',...
            'units','normalized',...
            'position',[.515 .14 .225 .1]);
uicontrol('Style','text','horizontalalign','center',...
            'String','in trials...',...
            'Units','normalized',...
            'Position',[.75 .835 .225 .05],...
            'fontsize',9);
h.tr2 = uicontrol('Style','listbox',...
            'Max',length(trList),...
            'String',stringList,'Value',[],...
            'Units','normalized',...
            'Position',[.75 .18 .225 .65]);


uicontrol('Style','pushbutton','String','Ok',...
            'backgroundcolor',[.65 1 .65],...
            'units','normalized',...
            'position',[.8 .05 .15 .1],...
            'callback',{@processCP,h,gui,m,sess,trList,bhvList});