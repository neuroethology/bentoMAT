function [mouse,enabled] = unpackExperiment(raw)
% parses the metadata in the excel sheet, then loads all of the listed
% files and formats their data.
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

%OS compatibility:
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'\',filesep);
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'/',filesep);
pth = raw{1,1};

fieldset = raw(2,:);
fieldset = fieldset(cellfun(@ischar,fieldset));
fieldset = strrep(fieldset,' ','_');
fieldset = strrep(fieldset,'_#','');
[data,match] = reconcileSheetFormats([],raw,fieldset);

if(isnumeric(raw{1,3})&~isnan(raw{1,3})) %if there's a common Ca framerate
    data(:,match.FR_Ca) = raw(1,3);
end
if(isnumeric(raw{1,5})&~isnan(raw{1,5})) %if there's a common bhvr movie framerate
    data(:,match.FR_Anno) = raw(1,5);
end

enabled.movie    = raw{1,11};
enabled.annot    = any(~cellfun(@isempty,data(:,match.Annotation_file)));
enabled.traces   = any(~cellfun(@isempty,data(:,match.Calcium_imaging_file)));
enabled.tracker  = any(~cellfun(@isempty,data(:,match.Tracking)));
enabled.features  = 0;%any(~cellfun(@isempty,data(:,match.Tracking)));
enabled.audio    = any(~cellfun(@isempty,data(:,match.Audio_file)));


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
    
    % load traces----------------------------------------------------------
    if(enabled.traces && ~isempty(data{i,match.Calcium_imaging_file}))
        fid     = [pth data{i,match.Calcium_imaging_file}];
        tstart  = data{i,match.Start_Ca};
        tstop   = data{i,match.Stop_Ca};
        CaFR    = data{i,match.FR_Ca};
        offset  = data{i,match.Offset};

        if(~strcmpi(fid,prevCa)) %save some time by not re-loading files used previously
            [rast,CaTime]    = unpackCaData(fid);
            if(size(rast,1)>size(rast,2))
                rast=rast';
            end
            prevCa  = fid;
        end
        cutCa = ~isempty(tstart)&&~isnan(tstart);
        if(cutCa)
            if(~isnumeric(tstart))
                tstart = str2num(tstart); tstop = str2num(tstop);
            end
            strtemp.rast = rast(:,tstart:tstop);
        else
            strtemp.rast = rast;
        end
        if(~isempty(CaTime))
            strtemp.CaTime   = CaTime;
            strtemp.CaFR     = 1/mean(CaTime(2:end)-CaTime(1:end-1)); % trust the timestamp over the user
        else
            strtemp.CaTime   = (1:size(strtemp.rast,2))/CaFR;
            strtemp.CaFR     = CaFR;
        end
        hasOffset = ~isempty(offset)&&~any(isnan(offset));
        if(hasOffset)
            if(~isnumeric(offset))
                offset = str2num(offset);
            end
            strtemp.CaTime  = strtemp.CaTime + offset;
        end
    else
        strtemp.CaTime=[];
        strtemp.rast=[];
    end
    
    % adds cross-day alignments if available. assumes for now that my data
    % format is being used.
    if(isfield(match,'Alignments')&&~isempty(data{i,match.Alignments}))
        fid = [pth data{i,match.Alignments}];
        sessn = ['session' num2str(data{i,match.Sessn})];
        load(fid);
        strtemp.rast_matched  = strtemp.rast(alignedCells.(sessn),:);
        strtemp.match         = alignedCells.(sessn);
        if(isfield(bounds,['day' sessn(end)]))
            if(exist('ICs'))
                strtemp.units         = ICs.(['day' sessn(end)]);
            else
                strtemp.units = [];
            end
            strtemp.bounds        = bounds.(['day' sessn(end)]);
        elseif(isfield(bounds,sessn))
            if(exist('ICs'))
                strtemp.units         = ICs.(sessn);
            else
                strtemp.units = [];
            end
            strtemp.bounds        = bounds.(sessn);
        else
            strtemp.units         = [];
        end
    else
        strtemp.rast_matched = [];
        strtemp.units = [];
    end
    
    % link movies----------------------------------------------------------
    if(enabled.movie && ~isempty(data{i,match.Behavior_movie}))
        movieList = strsplit(data{i,match.Behavior_movie},';');
        for j = 1:length(movieList)
            strtemp.io.movie.fid{j} = strtrim([pth strtrim(movieList{j})]);
        end
        
        strtemp.io.movie.FR  = data{i,match.FR_Anno};
        switch(strtemp.io.movie.fid{1}(end-2:end))
            case 'seq'
                strtemp.io.movie.readertype = 'seq';
            otherwise
                strtemp.io.movie.readertype = 'vid';
        end
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
                        info = VideoReader(strtemp.io.movie.fid{j});
                        tmax = min([tmax round(info.Duration*info.FrameRate)]);
                    end
            end
            strtemp.io.movie.tmax = tmax;
        end
        
    else
        strtemp.io.movie = struct();
    end
    
    % add tracking data----------------------------------------------------
    if(enabled.tracker)
        if(~isempty(data{i,match.Tracking}))
            fid = [pth data{i,match.Tracking}];
            [~,~,ext] = fileparts(fid);
            if(strcmpi(ext,'.mat'))
                strtemp.tracking.args = load(fid);
            elseif(strcmpi(ext,'.json'))
                strtemp.tracking.args = json_read_slow(fid);
            end
        else
            strtemp.tracking.args = [];
        end
    end
        
    % add audio data-------------------------------------------------------
    if(enabled.audio)
        if(~isempty(data{i,match.Audio_file}))
            [~,~,ext] = fileparts(data{i,match.Audio_file});
            if(strcmpi(ext,'mat'))
                fid             = [pth data{i.match.Audio_file}];
                strtemp.audio   = load(fid);
                
            elseif(~isempty(ls([pth strrep(data{i,match.Audio_file},ext,'_spectrogram.mat')])))
                fid             = [pth strrep(data{i,match.Audio_file},ext,'_spectrogram.mat')];
                strtemp.audio   = load(fid);
                
            else
                disp(['Processing file ' data{i,match.Audio_file}]);
                disp('Reading audio...');
                fid             = [pth data{i,match.Audio_file}];
                [y,fs]          = audioread(fid);
                disp('Generating spectrogram...');
                [~,f,t,psd]     = spectrogram(y,512,[],[],fs,'yaxis');
                psd             = 10*log10(abs(double(psd)+eps));
                disp('Saving spectrogram for future use...');
                fid             = [pth strrep(data{i,match.Audio_file},ext,'_spectrogram.mat')];
                save(fid,'f','t','psd','fs');
                disp('Done!');
                strtemp.audio.f   = f;
                strtemp.audio.t   = t;
                strtemp.audio.psd = psd;
                strtemp.audio.fs  = fs;
            end
            strtemp.audio.psd = imresize(strtemp.audio.psd,0.5);
            strtemp.audio.psd = strtemp.audio.psd(2:end-1,:);
            strtemp.audio.f = strtemp.audio.f(3:2:end-1);
            strtemp.audio.t = strtemp.audio.t(2:2:end);
        else
            strtemp.audio = [];
        end
    end
    
    % load annotations-----------------------------------------------------
    if(enabled.annot && ~isempty(data{i,match.Annotation_file}))
        annoList = strsplit(data{i,match.Annotation_file},';'); tmin = []; tmax = [];
        for j = 1:length(annoList)
            if(j>1), suff = ['_file' num2str(j)]; else suff=''; end
            if(contains(annoList{j}(end-4:end),'xls')) %old .annot format
                strtemp.io.annot.fid{j} = strrep([pth annoList{j}],'.xlsx','.annot'); %force conversion to .annot upon next save
                if(raw{1,9})
                    [atemp,~] = loadAnnotSheet([pth annoList{j}],data{i,match.Start_Anno},data{i,match.Stop_Anno});
                    tmin(j) = data{i,match.Start_Anno};
                    tmax(j) = data{i,match.Stop_Anno};
                else
                    [atemp,tmax(j)] = loadAnnotSheet([pth annoList{j}]);
                    tmin(j) = 1;
                end
            elseif(strcmpi(annoList{j}(end-5:end),'.annot')) %new .annot format
                strtemp.io.annot.fid{j} = strtrim([pth strtrim(annoList{j})]);
                if(raw{1,9})
                    [atemp,~] = loadAnnotSheetTxt([pth annoList{j}],data{i,match.Start_Anno},data{i,match.Stop_Anno});
                    tmin(j) = data{i,match.Start_Anno};
                    tmax(j) = data{i,match.Stop_Anno};
                else
                    [atemp,tmin(j),tmax(j)] = loadAnnotSheetTxt([pth annoList{j}]);
                end
            else		%load data in the old format, prepare to convert to sheet format when saved
                if(raw{1,9})
                    frame_suffix = ['_' num2str(data{i,match.Start_Anno}) '-' num2str(data{i,match.Stop_Anno}) '.annot'];
                    strtemp.io.annot.fid = strrep([pth [pth annoList{j}]],'.txt',frame_suffix);
                    [atemp,~] = loadAnnotFile([pth [pth annoList{j}]],data{i,match.Start_Anno},data{i,match.Stop_Anno});
                    tmin(j) = data{i,match.Start_Anno};
                    tmax(j) = data{i,match.Stop_Anno};
                else
                    strtemp.io.annot.fid = strrep([pth [pth annoList{j}]],'.txt','.annot');
                    [atemp,tmax(j)] = loadAnnotFile([pth annoList{j}]);
                    tmin(j) = 1;
                end
            end
            fields = fieldnames(atemp);
            for f = 1:length(fields)
                strtemp.annot.([fields{f} suff]) = atemp.(fields{f});
            end
        end
        strtemp.annot = orderfields(strtemp.annot);
        tmin = min(tmin);tmax=max(tmax);
        
        if(isnan(tmax))
            tmin = strtemp.io.movie.tmin;
            tmax = strtemp.io.movie.tmax;
        end
        strtemp.io.annot.tmin = tmin;
        strtemp.io.annot.tmax = tmax;
        strtemp.annoTime = (1:(tmax-tmin))/data{i,match.FR_Anno};
        
    elseif(enabled.movie && ~isempty(data{i,match.Behavior_movie}))
        strtemp.io.annot = struct();
        strtemp.io.annot.fid   = [];
        strtemp.io.annot.tmin = strtemp.io.movie.tmin;
        strtemp.io.annot.tmax = strtemp.io.movie.tmax;
        strtemp.annoFR   = strtemp.io.movie.FR;
        strtemp.annot = struct();
        strtemp.annoTime = (strtemp.io.annot.tmin:strtemp.io.movie.tmax)/strtemp.io.movie.FR;
    
    else
        strtemp.annot = struct();
        strtemp.annoTime = strtemp.CaTime;
        strtemp.io.annot = struct();
        strtemp.io.annot.fid   = [];
        strtemp.io.annot.tmin = 1;
        strtemp.io.annot.tmax = length(strtemp.CaTime);
        strtemp.annoFR   = strtemp.CaFR;
    end
    
    mouse(data{i,match.Mouse}).(['session' num2str(data{i,match.Sessn})])(data{i,match.Trial}) = strtemp;
end