function saveMovie(source)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



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

specs        = getMovieSpecs(gui,info);
isGif = strcmpi(specs.profile,'GIF');

if(~isGif)
    v            = VideoWriter(saveDataName,specs.profile);
    v.FrameRate  = specs.FR*specs.playback;
    if(strcmpi(specs.profile,'Motion JPEG AVI')|strcmpi(specs.profile,'MPEG-4'))
        v.Quality    = round(specs.quality);
    end
end

oldColor = [.94 .94 .94];
gui.h0.Color = specs.color;
visFlipped = [];
for i=1:length(gui.h0.Children)
    if(strcmpi(gui.h0.Children(i).Type,'uipanel'))
        gui.h0.Children(i).BackgroundColor = specs.color;
        for ii = 1:length(gui.h0.Children(i).Children)
            if(strcmpi(gui.h0.Children(i).Children(ii).Type,'uipanel'))
                gui.h0.Children(i).Children(ii).BackgroundColor = specs.color;
            elseif(strcmpi(gui.h0.Children(i).Children(ii).Type,'uicontrol'))
                visFlipped(i,ii) = strcmpi(gui.h0.Children(i).Children(ii).Visible,'on');
                if(visFlipped(i,ii))
                    gui.h0.Children(i).Children(ii).Visible = 'off';
                end
            end
        end
    end
end

oldSlider = gui.ctrl.slider;
gui.ctrl.slider.Value       = specs.startTime   + offset;
gui.ctrl.slider.Min         = specs.startTime   + offset;
gui.ctrl.slider.Max         = specs.endTime     + offset;
for i=1:length(gui.config.ctrl)
    gui.ctrl.(gui.config.ctrl{i}).panel.Visible='off';
end
if(specs.sliderOn)
    gui.ctrl.slider.panel.Visible = 'on';
    
    updateSlider(gui.h0,gui.ctrl.slider);
    updateSliderAnnot(gui);
else
    gui.enabled.ctrl(2) = 0;
end
redrawPanels(gui);

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
if(~isGif)
    open(v);
end
temp = [];
dt          = 1/specs.FR;
if(strcmpi(specs.bhvr,'all'))
    startTime   = specs.startTime;
    endTime     = specs.endTime;
else
    bouts = convertToBouts(gui.annot.bhv.(specs.bhvr))/gui.data.annoFR;
    bouts(bouts(:,2)<specs.startTime,:) = [];
    bouts(bouts(:,1)>specs.endTime,:)   = [];
    bouts = min(max(bouts,specs.startTime),specs.endTime);
    startTime   = bouts(:,1);
    endTime     = bouts(:,2);
end

for i = 1:length(startTime)
    for t = startTime(i):dt:endTime(i)
        gui.ctrl.slider.text.String = makeTime(t-specs.startTime);
        temp.Source.Tag = 'timeBox';
        updatePlot(gui.h0,temp);

        if(specs.sliderOn||(any(gui.enabled.movie(2)|gui.enabled.traces(2)|gui.enabled.audio(2))-1))
            img = getframe(gui.h0);
        elseif(gui.enabled.movie(2))
            img = getframe(gui.movie.axes);
        elseif(gui.enabled.traces(2))
            img = getframe(gui.traces.axes);
        elseif(gui.enabled.audio(2))
            img = getframe(gui.audio.axes);
        end
        if(isGif) 
            img = frame2im(img); 
            img = imresize(img,.5);
            [imind,cm] = rgb2ind(img,256); 
            if t==startTime(1) 
                imwrite(imind,cm,saveDataName,'gif', 'Loopcount',inf,'DelayTime',1/(specs.playback*specs.FR));
            else 
                imwrite(imind,cm,saveDataName,'gif','WriteMode','append','DelayTime',1/(specs.playback*specs.FR));
            end
        else
            writeVideo(v,img);
        end
    end
    for j=1:5
        if(isGif)

        else
            writeVideo(v,img); %add a pause at end of the bout
        end
    end
end
if(~isGif)
    close(v);
end
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
        for ii = 1:length(gui.h0.Children(i).Children)
            if(strcmpi(gui.h0.Children(i).Children(ii).Type,'uipanel'))
                gui.h0.Children(i).Children(ii).BackgroundColor = oldColor;
            elseif(strcmpi(gui.h0.Children(i).Children(ii).Type,'uicontrol') && visFlipped(i,ii))
                gui.h0.Children(i).Children(ii).Visible = 'on';
            end
        end
    end
end

for i=1:length(gui.config.ctrl)
    gui.ctrl.(gui.config.ctrl{i}).panel.Visible='on';
end
gui.ctrl.slider.Value       = oldSlider.Value;
gui.ctrl.slider.Min         = oldSlider.Min;
gui.ctrl.slider.Max         = oldSlider.Max;
updateSlider(gui.h0,gui.ctrl.slider);
updateSliderAnnot(gui);
gui.enabled.ctrl(2) = 1;
redrawPanels(gui);








