% function entryWindow(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



% exptGui = guidata(source);

clear h ss;
ss.panel = {'bordertype','line','units','pixels','highlightcolor',[.7 .7 .7],'fontsize',9};
ss.subpanel  = {'bordertype','none','units','pixels','fontsize',9};
ss.R = {'units','pixels','fontsize',9,'horizontalalign','right'};
ss.L = {'units','pixels','fontsize',9,'horizontalalign','left'};
ss.C = {'units','pixels','fontsize',9,'horizontalalign','center'};
ss.txt = [0 1 0 20];
ss.box = [0 1 0 25];
ss.rowsize = 30;

h.pth = pwd;
if(~strcmpi(h.pth(end),filesep))
    h.pth = [h.pth filesep];
end
h.ss = ss;
[h.fields,h.scalable] = deal([]);
close(figure(996));
h.f = figure(996);clf;
set(h.f,'units','pixels','dockcontrols','off','menubar','none','NumberTitle','off',...
    'position',[200 600 750 90],'resizefcn',@resizeEntryWindow);

h.bump = 10;
h.pTop          = uipanel(h.f,ss.subpanel{:},'units','pixels','position',[15 h.bump 750 ss.rowsize*2+20]);
h.expt.p        = uipanel(h.pTop,ss.panel{:},'title','Experiment info','position',[1 1 520 ss.rowsize*2+20]);
p               = uipanel(h.expt.p,ss.subpanel{:},'position',[5 36 510 30]);
temp(1)         = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[5 0 50 0],'string','Mouse');
h.expt.Mouse    = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[10 0 35 0],'string','1');
temp(2)         = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[15 0 50 0],'string','Session');
h.expt.Sess     = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[25 0 35 0],'string','1');
temp(3)         = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[35 0 50 0],'string','Trial');
h.expt.Trial    = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[45 0 35 0],'string','1');
temp(4)         = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[55 0 50 0],'string','Stim');
h.expt.Stim     = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[350 0 140 0],'string','');
align([temp,h.expt.Mouse,h.expt.Sess,h.expt.Trial,h.expt.Stim],'distribute','center')

clear temp;
p               = uipanel(h.expt.p,ss.subpanel{:},'position',[5 5 510 30]);
strs = getDatatypesList();
temp(1)         = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[50 0 80 0],'string','Add data type:');
h.expt.addField = uicontrol(p,ss.R{:},'style','popup','position',ss.box+[150 0 250 0],'string',strs,'callback',@entryWindowAddBox);
align([temp h.expt.addField],'distribute','center')

uicontrol(h.pTop,ss.C{:},'style','pushbutton','position',[560 5 150 ss.rowsize*2+10],'string','Add to table',...
          'backgroundcolor',[.65 1 .65],'callback',@addEntryToTable)

guidata(h.f,h);
