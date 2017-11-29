function [h2,row] = Audio_recordings(h,ss)

row = [];

p           = uipanel(h,ss.subpanel{:},'position',[5 96 710 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[10 0 70 0],'string','Audio data  ');
h2.fid      = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[80 0 530 0],'string','',...
                        'callback',{'Audio_Browse','fid'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[620 0 30 0],'string','...',...
                        'callback',{'Audio_Browse','fid'}');
row(1).p     = p;
row(1).scale = h2.fid;
row(1).fix   = temp;
align([row(1).scale row(1).fix],'distribute','center');

clear temp;
p           = uipanel(h,ss.subpanel{:},'position',[5 65 710 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[10 0 70 0],'string','Call annots  ');
h2.annot    = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[80 0 530 0],'string','',...
                        'callback',{'Audio_Browse','annot'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[620 0 30 0],'string','...',...
                        'callback',{'Audio_Browse','annot'}');
row(2).p     = p;
row(2).scale = h2.annot;
row(2).fix   = temp;
align([row(2).scale row(2).fix],'distribute','center')

clear temp;
p           = uipanel(h,ss.subpanel{:},'position',[5 34 710 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[20 0 60 0],'string','Log file  ');
h2.meta     = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[80 0 275 0],'string','',...
                        'callback',{'Audio_Browse','meta'});
temp(1,1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[300 0 30 0],'string','...',...
                        'callback',{'Audio_Browse','meta'});
temp(1,end+1) = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[301 0 1 0],'string','  ');
h2.metamenu = uicontrol(p,ss.L{:},'style','popupmenu','position',ss.box+[425 0 225 0],'string',' ',...
                        'callback',@Audio_changeMouse);
row(3).p     = p;
row(3).scale = [h2.meta h2.metamenu];
row(3).fix   = temp;
align([row(3).scale row(3).fix],'distribute','center');

clear temp;
p           = uipanel(h,ss.subpanel{:},'position',[5 3 710 30]);
temp(1)     = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[10 0 70 0],'string','Framerate  ');
h2.FR       = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[50 0 70 0],'string','');
temp(1,end+1) = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[55 0 80 0],'string','Frames  ');
h2.start    = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[65 0 70 0],'string','');
temp(1,end+1) = uicontrol(p,ss.C{:},'style','text','position',ss.txt+[75 0 25 0],'string','to');
h2.stop     = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[85 0 70 0],'string','');
temp(1,end+1) = uicontrol(p,ss.R{:},'style','text','position',ss.txt+[95 0 100 0],'string','Start time  ');
h2.time     = uicontrol(p,ss.C{:},'style','edit','position',ss.box+[500 0 150 0],'string','HH:MM:SS.SSS');
row(4).p      = p;
row(4).scale  = [h2.time h2.FR h2.start h2.stop];
row(4).fix    = temp;
align([row(4).scale row(4).fix],'distribute','center')






