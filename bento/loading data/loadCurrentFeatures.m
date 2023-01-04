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
    if ~isfield(data.tracking,'fun') || isempty(data.tracking.fun)
        data.tracking.fun = promptTrackType();
    end
    if(~isfield(data,'trackTime'))
        data.trackTime=[];
    end
    if(isempty(data.tracking.fun))
        gui.enabled.tracker = [0 0];
    elseif(isfield(data.io.movie,'reader'))
        [rr,cc] = identifyTrackedMovie(data);
        if(isfield(data.io.movie.reader{rr,cc},'TS') && isempty(data.trackTime))
            data.trackTime = data.io.movie.reader{rr,cc}.TS;
        end
    elseif(~isempty(data.annot) && isempty(data.trackTime))
        data.trackTime = data.annoTime;
    else
        data.trackTime = [];
    end
end

% TODO: update this to support features from multiple tracking files in one
% experiment
allfeats=cell(size(data.tracking.args));
if(strcmpi(data.tracking.fun,'generic_timeseries'))
    addFeats=true(size(data.tracking.args));
else
    addFeats=false(size(data.tracking.args));
    for i = 1:length(data.tracking.args)
        addFeats(i) = isfield(data.tracking.args{i},'features') ...
                        || contains(data.tracking.fun,'EMG') ...
                        || contains(data.tracking.fun,'jelly') ...
                        || contains(data.tracking.fun,'SimBA');
    end
end

for i = 1:length(data.tracking.args)
    if(addFeats(i))
        if(contains(data.tracking.fun,'jelly')) % hard-coded jellyfish support
            [data,allfeats{i}.featnames] = jellyfish_neurons_features(data, data.tracking.args{1});
            gui.enabled.traces = [1 1];
            gui.enabled.annot  = [1 1];
            gui.enabled.fineAnnot  = [1 0];
            gui.allData(data.info.mouse).(data.info.session)(data.info.trial).info = data.info;
            gui.allData(data.info.mouse).(data.info.session)(data.info.trial).trackTime = data.trackTime;
            gui.allData(data.info.mouse).(data.info.session)(data.info.trial) = data;
            allfeats{i}.features = data.tracking.features{i};

        elseif(strcmpi(data.tracking.fun,'EMG')) % hard-coded miller lab emg support
            [data,allfeats{i}.featnames] = EMG_features(data, data.tracking.args{1});
            gui.enabled.traces = [1 1];
            gui.enabled.annot  = [1 1];
            gui.enabled.fineAnnot  = [1 0];
            gui.allData(data.info.mouse).(data.info.session)(data.info.trial).info = data.info;
            gui.allData(data.info.mouse).(data.info.session)(data.info.trial).trackTime = data.trackTime;
            gui.allData(data.info.mouse).(data.info.session)(data.info.trial) = data;
            allfeats{i}.features = data.tracking.features{i};

        elseif(strcmpi(data.tracking.fun,'EMG_filtered')) % hard-coded miller lab emg support
            [data,allfeats{i}.featnames] = EMG_filtered_features(data, data.tracking.args{1});
            gui.enabled.traces = [1 1];
            gui.enabled.annot  = [1 1];
            gui.enabled.fineAnnot  = [1 0];
            gui.allData(data.info.mouse).(data.info.session)(data.info.trial).info = data.info;
            gui.allData(data.info.mouse).(data.info.session)(data.info.trial).trackTime = data.trackTime;
            gui.allData(data.info.mouse).(data.info.session)(data.info.trial) = data;
            allfeats{i}.features = permute(data.tracking.features{i},[3 1 2]);

        elseif(exist([data.tracking.fun '_features.m'],'file')) % user provided their own feature extraction fn
            [allfeats{i}.features,allfeats{i}.featnames] = eval([data.tracking.fun '_features(data.tracking.args{i})']);

        else % just ask which variables to use and hope for the best
            [allfeats{i}.features,allfeats{i}.featnames] = promptFeatures(data);

        end
    end
end

count=0;
formattedFeatNames={};
for i = 1:length(data.tracking.args)
    if(addFeats(i) && ~isempty(allfeats{i}))
        formattedFeats = allfeats{i}.features;
        nCh = size(formattedFeats,1);
        for j = 1:nCh
            count=count+1;
            data.tracking.features{count} = squeeze(formattedFeats(j,:,:));
            formattedFeatNames{count} = allfeats{i}.featnames;
        end
    end
end

if(count>0)
    gui.features.channels.String    = cellstr(strcat('Ch',num2str((1:length(data.tracking.features))')));
    gui.features.menu.String        = allfeats{1}.featnames;
    gui.features.featsByChannel     = formattedFeatNames;
end
