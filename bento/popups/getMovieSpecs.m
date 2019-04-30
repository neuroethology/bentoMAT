function specs = getMovieSpecs(gui,info)
% first frame, last frame, framerate, profile, quality, background color, show scrollbar
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



h.fig = figure(1);clf;
set(h.fig,'dockcontrols','off','menubar','none','position',[250 450 650 300],...
    'Tag','Movie Specs','name','Movie Settings','NumberTitle','off');
gui.browser = h.fig;

ss.panel = {'bordertype','line','units','normalized','highlightcolor',[.7 .7 .7],'fontsize',11};
ss.R = {'units','normalized','fontsize',10,'horizontalalign','right'};
ss.L = {'units','normalized','fontsize',10,'horizontalalign','left'};
ss.C = {'units','normalized','fontsize',10,'horizontalalign','center'};
strs = {'Motion JPEG AVI','Archival','Motion JPEG 2000','MPEG-4','Uncompressed AVI','Indexed AVI','Grayscale AVI'};
bhvs = ['all';strrep(fieldnames(gui.annot.bhv),'_',' ')];

h.quality  = uipanel(h.fig,ss.panel{:},'title','Quality settings','units','normalized','position',[.025 .6 .45 .35]);
h.display  = uipanel(h.fig,ss.panel{:},'title','Display','units','normalized','position',[.025 .05 .45 .55]);
h.frames   = uipanel(h.fig,ss.panel{:},'title','Segment to save','units','normalized','position',[.5 .05 .475 .55]);
h.go       = uipanel(h.fig,ss.panel{:},'bordertype','none','units','normalized','position',[.5 .6 .475 .375]);


uicontrol(h.frames,ss.R{:},'style','text','position',[.025 .725 .3 .2],'string','Start time');
uicontrol(h.frames,ss.R{:},'style','text','position',[.025 .5 .3 .2],'string','Stop time');
uicontrol(h.frames,ss.R{:},'style','text','position',[.025 .275 .3 .2],'string','Framerate (Hz)');
uicontrol(h.frames,ss.R{:},'style','text','position',[.025 .05 .3 .2],'string','Behavior');

h.startTime = uicontrol(h.frames,ss.C{:},'style','edit','position',[.4 .725 .4 .2],'string',makeTime(info.tmin));
h.endTime   = uicontrol(h.frames,ss.C{:},'style','edit','position',[.4 .5 .4 .2],'string',makeTime(info.tmax));
h.FR        = uicontrol(h.frames,ss.C{:},'style','edit','position',[.4 .275 .4 .2],'string','30');
h.bhvr      = uicontrol(h.frames,ss.C{:},'style','popup','position',[.4 .05 .4 .2],...
                        'string',bhvs);

h.hi        = uicontrol(h.quality,ss.R{:},'style','text','position',[.05 .2 .15 .225],'string','Low ','enable','on');
h.lo        = uicontrol(h.quality,ss.L{:},'style','text','position',[.8 .2 .15 .225],'string',' High','enable','on');
h.profile   = uicontrol(h.quality,ss.C{:},'style','popup','position',[.1 .5 .8 .35],...
                        'string',strs,'callback',@toggleMovieQuality);
h.qSlider   = uicontrol(h.quality,ss.C{:},'style','slider','position',[.2 .2 .6 .25],...
                        'min',0,'max',100,'value',75,'enable','on');

uicontrol(h.display,ss.R{:},'style','text','position',[.025 .725 .4 .2],'string','Background color');
uicontrol(h.display,ss.R{:},'style','text','position',[.025 .5 .4 .2],'string','Scrollbar visibility');
uicontrol(h.display,ss.R{:},'style','text','position',[.025 .275 .4 .2],'string','Play speed');
uicontrol(h.display,ss.R{:},'style','text','position',[.025 .05 .4 .2],'string','Title style');

h.bg        = uicontrol(h.display,ss.L{:},'style','popup','position',[.5 .725 .4 .225],'string',{'White','Black','Gray'});
h.sliderOn  = uicontrol(h.display,ss.L{:},'style','popup','position',[.5 .5 .4 .225],'string',{'On','Off'});
h.playSpeed = uicontrol(h.display,ss.L{:},'style','popup','position',[.5 .275 .4 .225],...
                        'string',{'8x','4x','2x','1x','0.5x','0.25x','0.125x'},'Value',4);
h.tStr  = uicontrol(h.display,ss.L{:},'style','popup','position',[.5 .05 .4 .225],'string',{'None','Short (mouse+stim)','Full (mouse, session, trial, stim)','Custom'});

uicontrol(h.go,ss.C{:},'backgroundcolor',[.65 1 .65],'style','pushbutton','position',[.2 .2 .6 .6],...
          'string','Go!','callback','uiresume(gcbf)');

guidata(h.fig,h);
uiwait(h.fig); %-----------------------------------------------------------



% extract settings!
specs.startTime = getTime(h.startTime.String);
specs.endTime   = getTime(h.endTime.String);
specs.FR        = str2num(h.FR.String);
specs.bhvr      = strrep(h.bhvr.String{h.bhvr.Value},' ','_');
specs.playback  = str2num(strrep(h.playSpeed.String{h.playSpeed.Value},'x',''));

specs.profile   = strs{h.profile.Value};
specs.quality   = h.qSlider.Value;
specs.title     = h.tStr.Value;
if(h.tStr.Value==4)
    specs.titleString = inputdlg('Enter movie title: ');
end

switch h.bg.Value
    case 1
        specs.color = [1 1 1];
    case 2
        specs.color = [0 0 0];
    case 3
        specs.color = [.94 .94 .94];
end

switch h.sliderOn.Value
    case 1
        specs.sliderOn = 1;
    otherwise
        specs.sliderOn = 0;
end

close(h.fig);
end

function toggleMovieQuality(source,~)

h = guidata(source);

if(any([1 4]==source.Value))
    h.qSlider.Enable = 'on';
    h.hi.Enable = 'on';
    h.lo.Enable = 'on';
else
    h.qSlider.Enable = 'off';
    h.hi.Enable = 'off';
    h.lo.Enable = 'off';
end

end







