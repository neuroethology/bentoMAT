function [h2,nRows,scale] = Behavior_video(h,ss)

nRows = 4;
scale = [];

p           = uipanel(h,ss.subpanel{:},'position',[5 96 700 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[30 0 80 0],'string','Video File  ');
h2.fid      = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[110 0 500 0],'string','',...
                        'callback',{'Behavior_Vid_Browse','fid'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[620 0 30 0],'string','...',...
                        'callback',{'Behavior_Vid_Browse','fid'}');
align([temp,h2.fid],'distribute','center')
scale(1).h = h2.fid;
scale(1).w = 120;
scale(1).post = temp(end);

clear temp;
p           = uipanel(h,ss.subpanel{:},'position',[5 65 710 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[30 0 80 0],'string','Annotations  ');
h2.anno     = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[110 0 500 0],'string','',...
                        'callback',{'Behavior_Vid_Browse','anno'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[620 0 30 0],'string','...',...
                        'callback',{'Behavior_Vid_Browse','anno'}');
align([temp,h2.anno],'distribute','center');
scale(2).h = h2.anno;
scale(2).w = 120;
scale(2).post = temp(end);

clear temp;
p           = uipanel(h,ss.subpanel{:},'position',[5 34 710 30]);
              uicontrol(p,ss.R{:},'style','text','position',ss.txt+[30 0 80 0],'string','Tracking data  ');
h2.track    = uicontrol(p,ss.L{:},'style','edit','position',ss.box+[110 0 500 0],'string','',...
                        'callback',{'Behavior_Vid_Browse','track'});
temp(1)     = uicontrol(p,ss.C{:},'style','pushbutton','position',ss.box+[620 0 30 0],'string','...',...
                        'callback',{'Behavior_Vid_Browse','track'}');
align([temp,h2.anno],'distribute','center');
scale(2).h = h2.anno;
scale(2).w = 120;
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