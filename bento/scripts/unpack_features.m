function expt = unpack_features(expt)

trFun = [];
for ex = 1:length(expt)
    if(isempty(expt(ex)))
        continue;
    end
    for f = fieldnames(expt(ex))'
        if(isempty(expt(ex).(f{:})))
            continue;
        end
        
        for tr = 1:length(expt(ex).(f{:}))
            data = expt(ex).(f{:})(tr);
            
            if isempty(trFun)
                trFun = promptTrackType();
            end
            
            data.tracking.fun = trFun;
            data.trackTime = data.annoTime; % will break if the annots are out of sync with the movie

            allfeats=cell(size(data.tracking.args));
            if(strcmpi(data.tracking.fun,'generic_timeseries'))
                addFeats = true(size(data.tracking.args));
            else
                addFeats = false(size(data.tracking.args));
                for i = 1:length(data.tracking.args)
                    addFeats(i) = isfield(data.tracking.args{i},'features') || contains(data.tracking.fun,'EMG') || contains(data.tracking.fun,'jelly');
                end
            end

            for i = 1:length(data.tracking.args)
                if(addFeats(i))
                    if(contains(data.tracking.fun,'jelly'))
                        % hard-coded jellyfish support
                        [data, data.tracking.featnames{i}] = jellyfish_neurons_features(data, data.tracking.args{1});

                    elseif(strcmpi(data.tracking.fun,'EMG'))
                        % hard-coded miller lab emg support
                        [data, data.tracking.featnames{i}] = EMG_features(data, data.tracking.args{1});

                    elseif(strcmpi(data.tracking.fun,'EMG_filtered'))
                        % hard-coded miller lab emg support
                        [data, data.tracking.featnames{i}] = EMG_filtered_features(data, data.tracking.args{1});

                    elseif(exist([data.tracking.fun '_features.m'],'file'))
                        % user provided their own feature extraction fn
                        [allfeats{i}.features,allfeats{i}.featnames] = eval([data.tracking.fun '_features(data.tracking.args{i})']);

                    else
                        % just ask which variables to use and hope for the best
                        [allfeats{i}.features,allfeats{i}.featnames] = promptFeatures(data);

                    end
                end
            end

            count = 0;
            for i = 1:length(data.tracking.args)
                if(addFeats(i) && ~isempty(allfeats{i}))
                    formattedFeats = allfeats{i}.features;
                    nCh = size(formattedFeats,1);
                    for j = 1:nCh
                        count=count+1;
                        data.tracking.features{count} = squeeze(formattedFeats(j,:,:));
                        data.tracking.featnames{count} = allfeats{i}.featnames(j,:);
                    end
                end
            end
            expt(ex).(f{:})(tr) = data;
        end
    end
end
