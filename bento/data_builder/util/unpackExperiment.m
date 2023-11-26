function [mouse,enabled,pth,hotkeys] = unpackExperiment(raw,skipvideos)
% parses the metadata in the excel sheet, then loads all of the listed
% files and formats their data.
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

for i = 3:size(raw,1)
    inds = [4 5 9 10 15 16 17];
    inds(inds>size(raw,2))=[];
    mask = cellfun(@sum,cellfun(@isnan,raw(i,inds),'uniformoutput',false));
    raw(i,inds(find(mask))) = {''};
    inds = setdiff(1:17,inds);
    inds(inds>size(raw,2))=[];
    mask = cellfun(@sum,cellfun(@isnan,raw(i,inds),'uniformoutput',false));
    raw(i,inds(find(mask))) = {[]};
end
if(~exist('skipvideos','var'))
    skipvideos = 0;
end

%OS compatibility for file paths:
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'\',filesep);
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'/',filesep);
pth = raw{1,1};
if(~isempty(pth))
    if(pth(end)~=filesep)
        if(isstr(pth))
            pth = [pth filesep];
        else
            pth = [];
        end
    end
end

[data,match,~] = reconcileSheetFormats([],raw);
hotkeys = struct();

if(isnumeric(raw{1,3})&&~isnan(raw{1,3})) %if there's a common Ca framerate
    data(:,match.FR_Ca) = raw(1,3);
end
if(isnumeric(raw{1,5})&&~isnan(raw{1,5})) %if there's a common bhvr movie framerate
    data(:,match.FR_Anno) = raw(1,5);
end

%window visibility:
enabled.movie     = any(~cellfun(@isempty,data(:,match.Behavior_movie)))*[1 1];
enabled.annot     = [1 1];
enabled.legend    = [1 any(~cellfun(@isempty,data(:,match.Annotation_file)))];
enabled.traces    = any(~cellfun(@isempty,data(:,match.Calcium_imaging_file)))*[1 1];
enabled.tracker   = any(~cellfun(@isempty,data(:,match.Tracking)))*[1 1];
enabled.features  = any(~cellfun(@isempty,data(:,match.Tracking)))*[1 0];
enabled.audio     = any(~cellfun(@isempty,data(:,match.Audio_file)))*[1 1];

enabled.tsne      = [0 0];
enabled.scatter   = any(~cellfun(@isempty,data(:,match.Calcium_imaging_file)))*[1 0];
enabled.fineAnnot = any(~cellfun(@isempty,data(:,match.Annotation_file)))*[1 0];

%load the data:
mouse = struct();
prevCa = '';
rast   = [];
CaTime = [];
for i=1:size(data,1)
    if(isempty(data{i,match.Mouse}))
        continue;
    end
    strtemp         = struct();
    strtemp.stim    = data{i,match.Stim};
    strtemp.CaFR    = data{i,match.FR_Ca};
    strtemp.annoFR  = data{i,match.FR_Anno};
    offset          = data{i,match.Offset};
    if(~isnumeric(offset))
        offset = str2num(offset);
    end
    hasOffset       = ~isempty(offset)&&~any(isnan(offset));
    
    % load traces----------------------------------------------------------
    if(~isempty(data{i,match.Calcium_imaging_file}))
        fid     = [pth strip(strip(data{i,match.Calcium_imaging_file},'left','.'),'left',filesep)];
        tstart  = data{i,match.Start_Ca};
        tstop   = data{i,match.Stop_Ca};
        CaFR    = data{i,match.FR_Ca};
        
        if(~strcmpi(fid,prevCa)) %save some time by not re-loading files used previously
            [rast,CaTime,spikes,ROIs]    = unpackCaData(fid);
            if(size(rast,1)>size(rast,2)) %sometimes data is stored transposed. we usually have more timepoints than cells, so use this fact to detect this
                rast=rast';spikes=spikes';
            end
            prevCa  = fid;
            strtemp.rast    = rast;
            strtemp.spikes  = spikes;
            strtemp.ROIs    = ROIs;
        else
            strtemp.rast    = rast;
            strtemp.spikes  = spikes;
            strtemp.ROIs    = ROIs;
        end
        cutCa = ~any(isempty(tstart))&&~any(isnan(tstart));
        if(cutCa)
            if(~isnumeric(tstart))
                tstart = str2num(tstart); tstop = str2num(tstop);
            end
            try
            strtemp.rast    = rast(:,tstart:tstop);
            catch
                keyboard
            end
            if(~isempty(spikes))
                strtemp.spikes  = spikes(:,tstart:tstop);
            end
        end
        strtemp.sm_rast = strtemp.rast;
        drdt = [zeros(size(strtemp.rast(:,1),1),1) strtemp.rast(:,2:end)-strtemp.rast(:,1:end-1)];
        strtemp.ddt = smoothts(drdt,'g',50,10)*20;
        if(~isempty(CaTime))
            strtemp.CaTime   = CaTime;
            strtemp.CaFR     = 1/mean(CaTime(2:end)-CaTime(1:end-1)); % trust the timestamp over the user
        else
            strtemp.CaTime   = (1:size(strtemp.rast,2))/CaFR;
            strtemp.CaFR     = CaFR;
        end
        if(hasOffset)
            strtemp.CaTime  = strtemp.CaTime + offset;
        end
        
        % for 2d plots:
        strtemp.proj.d1 = [];
        strtemp.proj.d2 = [];
    else
        strtemp.CaTime=[];
        strtemp.rast=[];
        strtemp.proj.d1=[];
        strtemp.proj.d2=[];
    end
    
    % adds cross-day alignments if available. assumes for now that my data
    % format is being used.
    if(isfield(match,'Alignments')&&~isempty(data{i,match.Alignments}))
        fid = [pth data{i,match.Alignments}];
        sessn = ['session' num2str(data{i,match.Sessn})];
        temp = load(fid);
        strtemp.rast_matched  = strtemp.rast(temp.alignedCells.(sessn),:);
        strtemp.match         = temp.alignedCells.(sessn);
        if(isfield(temp.bounds,['day' sessn(end)]))
            if(exist('ICs'))
                strtemp.units         = temp.ICs.(['day' sessn(end)]);
            else
                strtemp.units = [];
            end
            strtemp.bounds        = temp.bounds.(['day' sessn(end)]);
        elseif(isfield(temp.bounds,sessn))
            if(exist('ICs'))
                strtemp.units         = temp.ICs.(sessn);
            else
                strtemp.units = [];
            end
            strtemp.bounds        = temp.bounds.(sessn);
        else
            strtemp.units         = [];
        end
    else
        strtemp.rast_matched = [];
        strtemp.units = [];
    end
    
    % link movies----------------------------------------------------------
    if(~isempty(data{i,match.Behavior_movie}))
        colList   = strsplit(data{i,match.Behavior_movie},';;');
        
        for col = 1:length(colList)
            movieList = strsplit(colList{col},';');
            for j = 1:length(movieList)
                strtemp.io.movie.fid{col,j} = ...
                    strtrim([pth strip(strip(strtrim(movieList{j}),'left','.'),'left',filesep)]);
                
                switch(strtemp.io.movie.fid{col,j}(end-2:end))
                case 'seq'
                    strtemp.io.movie.readertype{col,j} = 'seq';
                otherwise
                    strtemp.io.movie.readertype{col,j} = 'vid';
                end
                
            end
        end
        strtemp.io.movie.FR  = data{i,match.FR_Anno}; %should change this to allow multiple FR's in the future
        
        if(~skipvideos)
            if(raw{1,9})
                strtemp.io.movie.tmin = data{i,match.Start_Anno};
                strtemp.io.movie.tmax = data{i,match.Stop_Anno};
            else
                strtemp.io.movie.tmin = 1;
                switch(strtemp.io.movie.fid{1}(end-2:end))
                    case 'seq'
                        tmax = inf;
                        for j = 1:length(strtemp.io.movie.fid)
                            info = seqIo(strtemp.io.movie.fid{j},'getInfo');
                            tmax = min([tmax info.numFrames]);
                        end
                    otherwise
                        tmax = inf;
                        for j = 1:length(strtemp.io.movie.fid)
                            try
                            info = VideoReader(strtemp.io.movie.fid{j});
                            catch
                                error(['I wasn''t able to find/load a video at: ' strtemp.io.movie.fid{j}]);
                            end
                            timestamps = getVideoTimestamps(strtemp.io.movie.fid{j});
                            if timestamps % check for timestamp files, update movie data accordingly
                                tmax = min([tmax length(timestamps)]);
                                strtemp.io.movie.FR = 1/mean(timestamps(2:end)-timestamps(1:end-1));
                            else
                                tmax = min([tmax round(info.Duration*info.FrameRate)]);
                            end
                            if(~isempty(data{i,match.Calcium_imaging_file}) && isempty(strtemp.CaTime)) % hack to check for accompanying Ca timestamps :[
                                timestamps = getVideoTimestamps(strtemp.io.movie.fid{j},'_Ca');
                                if timestamps
                                    strtemp.CaTime = timestamps(1:length(strtemp.rast))';
                                    strtemp.CaFR = 1/mean(timestamps(2:end)-timestamps(1:end-1));
                                end
                            end
                        end
                end
                strtemp.io.movie.tmax = tmax;
            end
        end
        
    else
        strtemp.io.movie = struct();
    end
    
    % add tracking data----------------------------------------------------
    if(enabled.tracker(1))
        strtemp.trackTime = [];
        if(~isempty(data{i,match.Tracking}))
            trackList = strsplit(data{i,match.Tracking},';');
            for trackFile = 1:length(trackList)
                strtemp = unpackTracking(pth, strtemp, trackList, trackFile);
            
                % everything that follows is shameful hacks!
                % we need a better way to get timestamps for the tracking data...
                if(isfield(strtemp,'tracking'))
                    if(isfield(strtemp.tracking.args{1},'keypoints') && isfield(strtemp.tracking.args{1},'fps'))
                        strtemp.trackTime = (1:length(strtemp.tracking.args{1}.keypoints))/double(strtemp.tracking.args{1}.fps);

                    elseif(isfield(strtemp.tracking.args{1},'tMax')) %hacks for jellyfish
                        strtemp.trackTime = (1:strtemp.tracking.args{1}.tMax)/strtemp.CaFR;

                    elseif isfield(strtemp.tracking.args{1},'fps')
                        if length(fieldnames(strtemp.tracking.args{1}))==2
                            datafield = setdiff(fieldnames(strtemp.tracking.args{1}),'fps');
                        elseif isfield(strtemp.tracking.args{1},'data') 
                            datafield = 'data';
                        elseif isfield(strtemp.tracking.args{1},'data_smooth')
                            datafield = 'data_smooth';
                        else
                            f = fieldnames(strtemp.tracking.args{1});
                            ans = inputdlg('Which field holds the tracking data?');
                            if isfield(strtemp.tracking.args{1},ans{:})
                                datafield = ans{:};
                            else
                                datafield = [];
                            end
                        end
                        if datafield
                            strtemp.trackTime = (1:length(strtemp.tracking.args{1}.(datafield)))/double(strtemp.tracking.args{1}.fps);
                        end

                    else
                        if(~isempty(data{i,match.Behavior_movie}) && length(strtemp.io.movie.fid)==1)
                            if(~strcmpi(strtemp.io.movie.fid{1}(end-2:end),'seq'))
                                timestamps = getVideoTimestamps(strtemp.io.movie.fid{1});
                            else
                                temp         	= seqIo(strtemp.io.movie.fid{1},'reader');
                                disp('getting timestamps...');
                                timestamps = getSeqTimestamps(strtemp.io.movie.fid{1},temp);
                            end
                            if(timestamps)
                                strtemp.trackTime = timestamps;
                                continue;
                            end
                        end

                        % I give up, let's just ask the user
                        ans = inputdlg('What''s the framerate of the tracking data?');
                        fps = str2num(ans{:});

                        if isnumeric(strtemp.tracking.args{1})
                            strtemp.trackTime = (1:length(strtemp.tracking.args{1}))/fps;
                        elseif length(fieldnames(strtemp.tracking.args{1}))==1
                            f = fieldnames(strtemp.tracking.args{1});
                            strtemp.trackTime = (1:length(strtemp.tracking.args{1}.(f{:})))/fps;
                        elseif length(fieldnames(strtemp.tracking.args{1}))==2
                            if isfield(strtemp.tracking.args{1},'data')
                                strtemp.trackTime = (1:length(strtemp.tracking.args{1}.data))/fps;
                            elseif isfield(strtemp.tracking.args{1},'data_smooth')
                                strtemp.trackTime = (1:length(strtemp.tracking.args{1}.data_smooth))/fps;
                            elseif isfield(strtemp.tracking.args{1},'features')
                                strtemp.trackTime = (1:length(strtemp.tracking.args{1}.features))/fps;
                            end
                        end
                    end
                end
            end
            
        else
            strtemp.tracking.args = [];
        end
    else
        strtemp.io.feat = [];
    end
        
    % add audio data-------------------------------------------------------
    if(enabled.audio(1))
        if(~isempty(data{i,match.Audio_file}))
            [~,~,ext] = fileparts(data{i,match.Audio_file});
            strSpect  = strip(strip(strrep(data{i,match.Audio_file},ext,'_spectrogram.mat'),'left','.'),'left',filesep);
            
            fid             = [pth strip(strip(data{i,match.Audio_file},'left','.'),'left',filesep)];
            loadSpect = 0;
            if(~isempty(strfind(fid,'spectrogram.mat')))
                loadSpect   = 1;
            elseif(~isempty(ls([pth strSpect])))
                loadSpect   = 1;
                fid         = [pth strSpect];
            end
            
            if(loadSpect)
                disp('Loading spectrogram...');
                strtemp.audio   = matfile(fid,'Writable',true);
            else
                disp(['Processing file ' data{i,match.Audio_file}]);
                disp('Reading audio...');
                fid             = [pth strip(strip(data{i,match.Audio_file},'left','.'),'left',filesep)];
                [y,fs]          = audioread(fid);
                disp('Generating spectrogram...');
                win = hann(1024);
                [~,f,t,psd]     = spectrogram(y,win,[],256,fs,'yaxis');
                psd             = 10*log10(abs(double(psd)+eps));
                disp('Saving spectrogram for future use...');
                fid             = [pth strip(strip(strrep(data{i,match.Audio_file},ext,'_spectrogram.mat'),'left','.'),'left',filesep)];
                save(fid,'-v7.3','f','t','psd','fs');
                strtemp.audio.f   = f;
                strtemp.audio.t   = t;
                strtemp.audio.psd = psd;
                strtemp.audio.fs  = fs;
            end
            disp('Done!');
            
%             strtemp.audio.psd = imresize(strtemp.audio.psd,0.5);
%             strtemp.audio.psd = strtemp.audio.psd(2:end-1,:);
%             strtemp.audio.f   = strtemp.audio.f(3:2:end-1);
%             strtemp.audio.t   = strtemp.audio.t(2:2:end);
            strtemp.audio.FR  = 1/(strtemp.audio.t(1,2)-strtemp.audio.t(1,1));
            
%             if(hasOffset)
%                 strtemp.audio.t  = strtemp.audio.t + offset;
%             end
            strtemp.audio.tmin = strtemp.audio.t(1,1);
            strtemp.audio.tmax = strtemp.audio.t(1,end);
        else
            strtemp.audio = [];
        end
    end
    
    % load annotations-----------------------------------------------------
    if(~isempty(data{i,match.Annotation_file}))
        [annot, tmin, tmax, allFR, strtemp.io.annot.fid, strtemp.io.annot.fidSave] = ...
            unpackAnnotFromLoader(pth, data{i,match.Annotation_file}, strtemp.annoFR, data{i,match.Start_Anno},data{i,match.Stop_Anno},raw{1,9});
        
        strtemp.annot           = orderfields(annot);
        tmin                    = min(tmin);
        tmax                    = max(tmax);
        [FR, strtemp.annot]     = setGlobalFR(allFR,strtemp.annot,strtemp.annoFR);
        strtemp.annoFR          = FR;
        strtemp.annoFR_source   = allFR; %for saving edited annotations back in their original FR
        
        if(isnan(tmax))
            tmin = strtemp.io.movie.tmin;
            tmax = strtemp.io.movie.tmax;
        end
        strtemp.io.annot.tmin   = tmin;
        strtemp.io.annot.tmax   = tmax;
        strtemp.io.annot.FR     = strtemp.annoFR;
        strtemp.annoTime        = (1:(tmax-tmin+1))/strtemp.annoFR;
        strtemp.io.movie.tmin   = tmin;
        strtemp.io.movie.tmax   = tmax;
        
    elseif(~isempty(data{i,match.Behavior_movie}))
        strtemp.io.annot        = struct();
        strtemp.io.annot.fid    = [];
        strtemp.io.annot.tmin   = strtemp.io.movie.tmin;
        strtemp.io.annot.FR     = strtemp.io.movie.FR;
        strtemp.annoFR          = strtemp.io.movie.FR; % change default annotation framerate to match the movie
        strtemp.io.annot.tmax   = ceil(strtemp.io.movie.tmax * strtemp.annoFR/strtemp.io.movie.FR);
        strtemp.annoFR_source = strtemp.annoFR;
        strtemp.annot           = struct();
        strtemp.annoTime        = (strtemp.io.annot.tmin:strtemp.io.annot.tmax)/strtemp.io.annot.FR;
        
    elseif(~isempty(data{i,match.Audio_file}))
        strtemp.io.annot        = struct();
        strtemp.io.annot.fid    = [];
        strtemp.io.annot.tmin   = strtemp.audio.tmin;
        strtemp.io.annot.tmax   = ceil(strtemp.audio.tmax * strtemp.annoFR/strtemp.audio.FR);
        strtemp.io.annot.FR     = strtemp.audio.FR;
        strtemp.annoFR          = strtemp.io.movie.FR; % change default annotation framerate to match the audio
        strtemp.annoFR_source = strtemp.annoFR;
        strtemp.annoTime        = strtemp.io.annot.tmin:(1/strtemp.annoFR):strtemp.io.annot.tmax;
        strtemp.annot           = struct();
           
    elseif(~isempty(data{i,match.Tracking}) && ~isempty(strtemp.trackTime))
        strtemp.io.annot        = struct();
        strtemp.io.annot.fid    = [];
        strtemp.io.annot.tmin   = 1;
        strtemp.io.annot.tmax   = length(strtemp.trackTime);
        strtemp.io.annot.FR     = 1/(strtemp.trackTime(2)-strtemp.trackTime(1));
        strtemp.annoFR          = 1/(strtemp.trackTime(2)-strtemp.trackTime(1));
        strtemp.annoFR_source = strtemp.annoFR;
        strtemp.annoTime        = strtemp.io.annot.tmin:(1/strtemp.annoFR):strtemp.io.annot.tmax;
        strtemp.annot           = struct();
    else
        strtemp.annot           = struct();
        strtemp.annoTime        = strtemp.CaTime;
        strtemp.io.annot        = struct();
        strtemp.io.annot.fid    = [];
        strtemp.io.annot.tmin   = 1;
        strtemp.io.annot.tmax   = length(strtemp.CaTime);
        strtemp.io.annot.FR     = strtemp.CaFR;
        strtemp.annoFR          = strtemp.CaFR;
        strtemp.annoFR_source = strtemp.annoFR;
    end
    
    try
    mouse(data{i,match.Mouse}).(['session' num2str(data{i,match.Sessn})])(data{i,match.Trial}) = strtemp;
    catch
        keyboard
    end
end
