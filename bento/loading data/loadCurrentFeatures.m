function data = loadCurrentFeatures(gui,data)

if(isfield(gui,'data'))
    data.tracking.fun = gui.data.tracking.fun;
    if(isfield(data.io.movie,'reader'))
        [rr,cc] = identifyTrackedMovie(data);
        data.trackTime = gui.data.io.movie.reader{rr,cc}.TS;
    else
        data.trackTime = data.annoTime;
    end
else
    data.tracking.fun = promptTrackType();
    if(isempty(data.tracking.fun))
        gui.enabled.tracker = [0 0];
    elseif(isfield(data.io.movie,'reader'))
        [rr,cc] = identifyTrackedMovie(data);
        data.trackTime = data.io.movie.reader{rr,cc}.TS;
    else
        data.trackTime = data.annoTime;
    end
end

if(isfield(data.tracking.args,'features'))

    if(exist([data.tracking.fun '_features.m'],'file')) % user provided their own feature extraction fn
        [data.tracking.features,featnames] = eval([data.tracking.fun '_features(data.tracking.args)']);

    elseif(~isempty(strfind(data.tracking.fun,'MARS'))) %hard-coded MARS-top support
        [data.tracking.features,featnames] = MARS_top_features(data.tracking.args);

    else % just ask which variables to use and hope for the best
        [data.tracking.features,featnames] = promptFeatures(data);

    end
    gui.features.channels.String    = cellstr(strcat('Ch',num2str((1:size(data.tracking.features,1))')));
    gui.features.menu.String        = featnames;
end
