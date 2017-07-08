function launchFinder(source,~)

gui = guidata(source);
h = figure();clf;
set(h,'units','pixels','dockcontrols','off','menubar','none','NumberTitle','off',...
    'position',[1000 100 350 600],'resizefcn',@redrawFinder);
fillin = {'units','normalized','fontsize',12};

uicontrol('style','text',fillin{:},'position',[0 .775 1 .225],'string','');
uicontrol('style','text',fillin{:},'position',[0 .94 1 .05],'string','File finder','fontweight','bold');

uicontrol('style','text',fillin{:},'position',[0 .915 .35 .035],'string','Parent directory:','horizontalalign','right');
uicontrol('style','text',fillin{:},'position',[.38 .92 .6 .035],'string',get(gui.root,'string'),'horizontalalign','left');

uicontrol('style','text',fillin{:},'position',[0 .875 .35 .035],'string','Filename format:','horizontalalign','right');
gui.Castr       = uicontrol('style','edit',fillin{:},'position',[.38 .88 .6 .035],'string','*.*','horizontalalign','left');

gui.tCa         = uitable('parent',h,fillin{:},'position',[.01 .01 .98 .81],'columnname','','rowname','',...
                'columneditable',true,'data','','columnwidth',{.93*350});

uicontrol('style','pushbutton',fillin{:},'position',[.7 .835 .2 .035],'string','Go','callback',@findFiles);
guidata(h,gui);