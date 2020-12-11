function [gui,data] = loadCurrentFeatures(gui,data)

if(isfield(gui,'data'))
    data.tracking.fun = gui.data.tracking.fun;
    if(~isfield(data.io.movie,'reader'))
        data.trackTime = data.annoTime;
    else
        [rr,cc] = identifyTrackedMovie(data);
        if(isfield(data.io.movie.reader{rr,cc},'TS'))
            data.trackTime = gui.data.io.movie.reader{rr,cc}.TS;
        else
            data.trackTime = data.annoTime;
        end
    end
else
    data.tracking.fun = promptTrackType();
    if(isempty(data.tracking.fun))
        gui.enabled.tracker = [0 0];
    elseif(isfield(data.io.movie,'reader'))
        [rr,cc] = identifyTrackedMovie(data);
        if(isfield(data.io.movie.reader{rr,cc},'TS'))
            data.trackTime = data.io.movie.reader{rr,cc}.TS;
        else
            data.trackTime = data.annoTime;
        end
    end
end

% TODO: update this to support features from multiple tracking files in one
% experiment
if(isfield(data.tracking.args{1},'features') || contains(data.tracking.fun,'EMG'))

    if(strcmpi(data.tracking.fun,'EMG')) % hard-coded miller lab emg support
        [data,featnames] = EMG_features(data, data.tracking.args{1});
        gui.enabled.traces = [1 1];
        gui.enabled.annot  = [1 1];
        gui.enabled.fineAnnot  = [1 0];
        gui.allData(data.info.mouse).(data.info.session)(data.info.trial).info = data.info;
        gui.allData(data.info.mouse).(data.info.session)(data.info.trial).trackTime = data.trackTime;
        gui.allData(data.info.mouse).(data.info.session)(data.info.trial) = data;
        
    elseif(strcmpi(data.tracking.fun,'EMG_filtered')) % hard-coded miller lab emg support
        [data,featnames] = EMG_filtered_features(data, data.tracking.args{1});
        gui.enabled.traces = [1 1];
        gui.enabled.annot  = [1 1];
        gui.enabled.fineAnnot  = [1 0];
        gui.allData(data.info.mouse).(data.info.session)(data.info.trial).info = data.info;
        gui.allData(data.info.mouse).(data.info.session)(data.info.trial).trackTime = data.trackTime;
        gui.allData(data.info.mouse).(data.info.session)(data.info.trial) = data;
        
    elseif(exist([data.tracking.fun '_features.m'],'file')) % user provided their own feature extraction fn
        [data.tracking.features,featnames] = eval([data.tracking.fun '_features(data.tracking.args{1})']);

    elseif(~isempty(strfind(data.tracking.fun,'MARS'))) %hard-coded MARS-top support
        [data.tracking.features,featnames] = MARS_top_features(data.tracking.args{1});

    else % just ask which variables to use and hope for the best
        [data.tracking.features,featnames] = promptFeatures(data);

    end
    gui.features.channels.String    = cellstr(strcat('Ch',num2str((1:size(data.tracking.features,1))')));
    gui.features.menu.String        = featnames;
end
