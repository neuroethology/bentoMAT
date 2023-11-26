function gui = applySliderUpdates(gui,type,info)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



% remove existing annotation data:
set(gui.ctrl.slider.bg,'CData',[]);

switch type
    case 'movie'
        if(strcmpi(info.readertype{1,1},'seq'))
            Fr = info.FR; % use the experimenter-set value
            tMax = info.reader{1,1}.numFrames/Fr;
        else
%             Fr = info.reader{1,1}.reader.FrameRate;
%             tMax = info.reader{1,1}.reader.Duration;
            Fr = info.FR;
            tMax = info.tmax/Fr;
        end
        maxVal = min(tMax,info.tmax/info.FR);
        minVal = max(1/Fr,info.tmin/info.FR);
    case 'Ca'
        minVal  = 0;
        maxVal  = info.annoTime(end);
        Fr      = 1/(info.annoTime(2)-info.annoTime(1));
    case 'audio'
        minVal  = 0;
        maxVal  = info.audio.t(1,end);
        Fr      = 1/(info.audio.t(1,2)-info.audio.t(1,1));
    case 'tracker'
        minVal = 0;
        maxVal = info.trackTime(end);
        Fr     = 1/(info.trackTime(2)-info.trackTime(1));
    otherwise % annotations really shouldn't be the last choice- it should 
              % override all other fields for setting the slider bounds,
              % since annotations are what's displayed on the slider.
        Fr      = info.annoFR;
        minVal  = 0;
        maxVal  = info.annoTime(end) - info.annoTime(1);
end
        
% change the slider limits and resets it to start
gui.ctrl.slider.Max         = maxVal;
gui.ctrl.slider.Min         = minVal;
gui.ctrl.slider.SliderStep  = [1/Fr 1];
gui.ctrl.slider.Value       = gui.ctrl.slider.Min;
updateSlider(gui.h0,gui.ctrl.slider);