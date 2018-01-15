function saveMovie(source,~)

gui = guidata(source);
[FileName,PathName] = uiputfile(...
                {'*.avi;', 'AVI file (*.avi)';...
                 '*.mp4', 'MP4 file (*.mp4)';...
                 '*.*',  'All Files (*.*)'},'Save As');
saveDataName = fullfile(PathName,FileName);
offset    = gui.ctrl.slider.Min;
info.tmin = gui.ctrl.slider.Value - offset;
info.tmax = gui.ctrl.slider.Max - offset;
data      = gui.data; % back up full versions of data
annot     = gui.annot;

specs        = getMovieSpecs(info);
v            = VideoWriter(saveDataName,specs.profile);
v.FrameRate  = specs.FR*specs.playback;
if(strcmpi(specs.profile,'Motion JPEG AVI')|strcmpi(specs.profile,'MPEG-4'))
    v.Quality    = round(specs.quality);
end

oldColor = gui.h0.Color;
gui.h0.Color = specs.color;
for i=1:length(gui.h0.Children)
    if(strcmpi(gui.h0.Children(i).Type,'uipanel'))
        gui.h0.Children(i).BackgroundColor = specs.color;
    end
end

oldSlider = gui.ctrl.slider;
for i=1:length(gui.config.ctrl)
    gui.ctrl.(gui.config.ctrl{i}).panel.Visible='off';
end
if(specs.sliderOn)
    gui.ctrl.slider.panel.Visible = 'on';
    gui.ctrl.labels.panel.Visible = 'on';
    gui.ctrl.labels.panel.BackgroundColor = specs.color;
    gui.ctrl.slider.Value       = specs.startTime+offset;
    gui.ctrl.slider.Min         = specs.startTime+offset;
    gui.ctrl.slider.Max         = specs.endTime+offset;

    addLabelLegend(gui,specs);
    updateSlider(gui.h0,gui.ctrl.slider);
    updateSliderAnnot(gui);
else
    gui.enabled.ctrl(2) = 0;
end
redrawPanels(gui);

frCut = round(specs.startTime*gui.data.annoFR);
for chNum = 1:length(gui.annot.channels)
    chName = gui.annot.channels{chNum};
    for f = fieldnames(gui.data.annot.(chName))'
        gui.data.annot.(chName).(f{:}) = gui.data.annot.(chName).(f{:}) - frCut;
    end
end
gui.data.annoTime = gui.data.annoTime - specs.startTime;
if(~isempty(gui.data.rast))
    gui.data.CaTime = gui.data.CaTime - specs.startTime;
end
guidata(gui.h0,gui);

if(specs.title~=1 && all(gui.enabled.movie))
    if(specs.title==2)
        tstr = ['Mouse ' num2str(gui.data.info.mouse) ', stimulus: ' strrep(gui.data.stim,'_',' ')];
    elseif(specs.title==3)
        s = regexp(gui.data.info.session,['\d+\.?\d*'],'match');
        tstr = {['Mouse ' num2str(gui.data.info.mouse) ', session ' s{:} ...
                ', trial ' num2str(gui.data.info.trial)],['stimulus: ' strrep(gui.data.stim,'_',' ')]};
    elseif(specs.title==4)
        tstr = specs.titleString;
    end
    title(gui.movie.axes,tstr);
end

% this is the actual save loop!--------------------------------------------
open(v);
temp = [];
for t = (specs.startTime : 1/specs.FR : specs.endTime)
    gui.ctrl.slider.text.String = makeTime(t-specs.startTime);
    temp.Source.Tag = 'timeBox';
    updatePlot(gui.h0,temp);
    
    img = getframe(gui.h0);
    writeVideo(v,img);
end
close(v);
% -------------------------------------------------------------------------

gui.data = data;
gui.annot = annot;
guidata(gui.h0,gui);
if(specs.title~=1 && all(gui.enabled.movie))
    title(gui.movie.axes,'');
end

gui.h0.Color = oldColor;
for i=1:length(gui.h0.Children)
    if(strcmpi(gui.h0.Children(i).Type,'uipanel'))
        gui.h0.Children(i).BackgroundColor = oldColor;
    end
end

for i=1:length(gui.config.ctrl)
    gui.ctrl.(gui.config.ctrl{i}).panel.Visible='on';
    gui.ctrl.labels.panel.Visible = 'off';
    gui.ctrl.labels.panel.BackgroundColor = oldColor;
end
gui.ctrl.slider.Value       = oldSlider.Value;
gui.ctrl.slider.Min         = oldSlider.Min;
gui.ctrl.slider.Max         = oldSlider.Max;
updateSlider(gui.h0,gui.ctrl.slider);
updateSliderAnnot(gui);
gui.enabled.ctrl(2) = 1;
redrawPanels(gui);








