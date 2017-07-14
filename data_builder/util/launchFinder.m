function launchFinder(source,~)

gui = guidata(source);
h = figure(998);clf;
set(h,'units','pixels','dockcontrols','off','menubar','none','NumberTitle','off',...
    'position',[1000 100 350 600],'resizefcn',@redrawFinder);
fillin = {'units','normalized','fontsize',12};

uicontrol('style','text',fillin{:},'position',[0 .775 1 .225],'string','');
uicontrol('style','text',fillin{:},'position',[0 .94 1 .05],'string','File finder','fontweight','bold');

uicontrol('style','text',fillin{:},'position',[0 .915 .35 .035],'string','Parent directory:','horizontalalign','right');
uicontrol('style','text',fillin{:},'position',[.38 .92 .6 .035],'string',get(gui.root,'string'),'horizontalalign','left');

uicontrol('style','text',fillin{:},'position',[0 .875 .35 .035],'string','Filename format:','horizontalalign','right');
gui.Castr       = uicontrol('style','edit',fillin{:},'position',[.38 .88 .4 .035],'string','*.*','horizontalalign','left');

gui.tCa         = uitable('parent',h,fillin{:},'position',[.01 .01 .98 .81],'columnname','','rowname','',...
                'columneditable',true,'data','','columnwidth',{.93*350},...
                'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));

uicontrol('style','pushbutton',fillin{:},'position',[.8 .88 .15 .035],'string','Go','callback',@findFiles);
uicontrol('style','pushbutton',fillin{:},'position',[.625 .835 .30 .035],'string','<< Add  ','callback',@addFile);
guidata(h,gui);