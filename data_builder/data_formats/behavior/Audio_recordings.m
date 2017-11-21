function [h2,nRows,scale] = Audio_recordings(h,ss)

nRows = 4;
scale = [];

p           = uipanel(h,ss.subpanel{:},'position',[5 96 700 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[20 0 60 0],'string','Audio file  ');
h2.fid      = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[80 0 530 0],'string','',...
                        'callback',{'Audio_Browse','fid'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[620 0 30 0],'string','...',...
                        'callback',{'Audio_Browse','fid'}');
align([temp,h2.fid],'distribute','center')
scale(1).h = h2.fid;
scale(1).w = 120;
scale(1).post = temp(end);

clear temp;
p           = uipanel(h,ss.subpanel{:},'position',[5 96 700 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[20 0 60 0],'string','Event annotations  ');
h2.annot    = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[80 0 530 0],'string','',...
                        'callback',{'Audio_Browse','annot'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[620 0 30 0],'string','...',...
                        'callback',{'Audio_Browse','annot'}');
align([temp,h2.fid],'distribute','center')
scale(1).h = h2.fid;
scale(1).w = 120;
scale(1).post = temp(end);

clear temp;
p           = uipanel(h,ss.subpanel{:},'position',[5 34 710 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[20 0 60 0],'string','Log file  ');
h2.meta     = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[80 0 275 0],'string','',...
                        'callback',{'Audio_Browse','meta'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[300 0 30 0],'string','...',...
                        'callback',{'Audio_Browse','meta'});
temp(end+1) = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[301 0 1 0],'string','  ');
h2.metamenu = uicontrol(p,ss.L{:},'style','popupmenu','position',ss.box+[425 0 225 0],'string',' ',...
                        'callback',@Audio_changeMouse);
align([temp,h2.meta,h2.metamenu],'distribute','center');
scale(2).h = h2.meta;
scale(2).w = 90;
scale(2).post = temp(end);

clear temp;
p           = uipanel(h,ss.subpanel{:},'position',[5 3 710 30]);
temp(1)     = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[10 0 70 0],'string','Framerate  ');
h2.FR       = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[50 0 70 0],'string','');
temp(end+1) = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[55 0 80 0],'string','Frames  ');
h2.start    = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[65 0 70 0],'string','');
temp(end+1) = uicontrol(p,ss.C{:},'style','text','position',ss.txt+[75 0 25 0],'string','to');
h2.stop     = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[85 0 70 0],'string','');
temp(end+1) = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[95 0 100 0],'string','Start time  ');
h2.time     = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[500 0 150 0],'string','HH:MM:SS.SSS');
scale(3).h  = h2.time;
scale(3).w  = 350;
scale(3).post = [];

align([temp,h2.FR,h2.start,h2.stop,h2.time],'distribute','center')