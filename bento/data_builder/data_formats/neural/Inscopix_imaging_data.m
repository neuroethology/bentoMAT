function [h2,row] = Inscopix_imaging_data(h,ss)

row = [];

p           = uipanel(h,ss.subpanel{:},'position',[5 65 700 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[20 0 60 0],'string','Data file  ');
h2.fid      = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[80 0 530 0],'string','',...
                        'callback',{'Inscopix_Browse','meta'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[620 0 30 0],'string','...',...
                        'callback',{'Inscopix_Browse','fid'}');
align([temp,h2.fid],'distribute','center')
row(1).p     = p;
row(1).scale = h2.fid;
row(1).fix   = temp;
align([row(1).scale row(1).fix],'distribute','center')


clear temp;
p           = uipanel(h,ss.subpanel{:},'position',[5 34 710 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[20 0 60 0],'string','Log file  ');
h2.meta     = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[80 0 275 0],'string','',...
                        'callback',{'Inscopix_Browse','meta'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[300 0 30 0],'string','...',...
                        'callback',{'Inscopix_Browse','meta'});
temp(end+1) = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[301 0 1 0],'string','  ');
h2.metamenu = uicontrol(p,ss.L{:},'style','popupmenu','position',ss.box+[425 0 225 0],'string',' ',...
                        'callback',@Inscopix_changeMouse);
align([temp,h2.meta,h2.metamenu],'distribute','center');
row(2).p     = p;
row(2).scale = [h2.meta h2.metamenu];
row(2).fix   = temp;
align([row(2).scale row(2).fix],'distribute','center')

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
row(3).p     = p;
row(3).scale = [h2.time h2.FR h2.start h2.stop];
row(3).fix   = temp;
align([row(3).scale row(3).fix],'distribute','center')