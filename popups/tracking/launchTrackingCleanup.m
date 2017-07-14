% function launchTrackingCleanup(source,~)

% gui = guidata(source);
% need a way to pass the current frame number in!

h.fig = figure('dockcontrols','off','menubar','none',...
    'Tag','Tracking','name','Edit tracking data','NumberTitle','off');
gui.browser = h.fig;
p = get(h.fig,'Position');
set(h.fig,'Position',[p(1:2)+[160 0] 250 300]);

% box to set number of active elements
uicontrol('Style','text','horizontalalign','left',...
            'String','Number of objects being tracked',...
            'Units','normalized',...
            'Position',[.4 .8 .5 .125],...
            'fontsize',11);
h.bhv1 = uicontrol('Style','edit',...
            'String','0',...
            'Units','normalized',...
            'Position',[.1 .8125 .25 .1],...
            'fontsize',11,...
            'callback',@(src,evt,gui,ind)eval(['gui.data.tracking.active{ind}=1:' src.String ')']));

% button to switch two elements


% button to manually place an element


% button to crop frame/revert crop


% button to save your work to a file