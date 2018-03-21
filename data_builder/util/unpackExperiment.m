function [mouse,enabled,pth] = unpackExperiment(raw)
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
if(pth(end)~=filesep)
    pth = [pth filesep];
end

fieldset = raw(2,:);
fieldset = fieldset(cellfun(@ischar,fieldset));
fieldset = strrep(fieldset,' ','_');
fieldset = strrep(fieldset,'_#','');
[data,match] = reconcileSheetFormats([],raw,fieldset);

if(isnumeric(raw{1,3})&&~isnan(raw{1,3})) %if there's a common Ca framerate
    data(:,match.FR_Ca) = raw(1,3);
end
if(isnumeric(raw{1,5})&&~isnan(raw{1,5})) %if there's a common bhvr movie framerate
    data(:,match.FR_Anno) = raw(1,5);
end

%window visibility:
enabled.movie     = any(~cellfun(@isempty,data(:,match.Behavior_movie)))*[1 1];
enabled.annot     = any(~cellfun(@isempty,data(:,match.Annotation_file)))*[1 1];
enabled.legend    = enabled.annot;
enabled.traces    = any(~cellfun(@isempty,data(:,match.Calcium_imaging_file)))*[1 1];
enabled.tracker   = any(~cellfun(@isempty,data(:,match.Tracking)))*[1 1];
enabled.features  = any(~cellfun(@isempty,data(:,match.Tracking)))*[1 1];
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
    if(enabled.traces(1) && ~isempty(data{i,match.Calcium_imaging_file}))
        fid     = [pth strip(strip(data{i,match.Calcium_imaging_file},'left','.'),'left',filesep)];
        tstart  = data{i,match.Start_Ca};
        tstop   = data{i,match.Stop_Ca};
        CaFR    = data{i,match.FR_Ca};
        
        if(~strcmpi(fid,prevCa)) %save some time by not re-loading files used previously
            [rast,CaTime]    = unpackCaData(fid);
            if(size(rast,1)>size(rast,2))
                rast=rast';
            end
            prevCa  = fid;
            strtemp.rast = rast;
%             [~,ctrs] = kmeans(zscore(rast')',10,'replicates',10);
            ctrs = rast;
            strtemp.ctrs = ctrs;
        end
        cutCa = ~any(isempty(tstart))&&~any(isnan(tstart));
        if(cutCa)
            if(~isnumeric(tstart))
                tstart = str2num(tstart); tstop = str2num(tstop);
            end
            strtemp.rast = rast(:,tstart:tstop);
            strtemp.ctrs = ctrs(:,tstart:tstop);
        end
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
    
    % link tSNE/scatter data-----------------------------------------------
%     if(enabled.tsne(1) && ~isempty(data{i,match.tSNE}))
%         temp = load([pth data{i,match.tSNE}]);
%         f = fieldnames(temp);
%         temp=temp.(f{:});
%         if(size(temp,1)==2)
%             temp=temp';
%         end
%         strtemp.tsne = temp;
%     end
    
    % link movies----------------------------------------------------------
    if(enabled.movie(1) && ~isempty(data{i,match.Behavior_movie}))
        movieList = strsplit(data{i,match.Behavior_movie},';');
        for j = 1:length(movieList)
            strtemp.io.movie.fid{j} = strtrim([pth strip(strip(strtrim(movieList{j}),'left','.'),'left',filesep)]);
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
                        try
                        info = VideoReader(strtemp.io.movie.fid{j});
                        catch
                            keyboard
                        end
                        tmax = min([tmax round(info.Duration*info.FrameRate)]);
                    end
            end
            strtemp.io.movie.tmax = tmax;
        end
        
    else
        strtemp.io.movie = struct();
    end
    
    % add tracking data----------------------------------------------------
    if(enabled.tracker(1))
        if(~isempty(data{i,match.Tracking}))
            fid = [pth strip(strip(data{i,match.Tracking},'left','.'),'left',filesep)];
            [~,~,ext] = fileparts(fid);
            if(strcmpi(ext,'.mat'))
                temp = load(fid);
                f = fieldnames(temp);
                if(length(f)==1)
                    temp=temp.(f{:});
                end
                strtemp.tracking.args = temp;
                strtemp.io.feat.fid = fid;
            elseif(strcmpi(ext,'.json'))
                if(exist('jsondecode','builtin'))
                    strtemp.tracking.args = jsondecode(fileread(fid));
                elseif(exist('loadjson','file'))
                    disp('Using loadjson.')
                    strtemp.tracking.args = loadjson(fid);
                else
                    disp('Please download jsonlab (https://github.com/fangq/jsonlab) or upgrade to Matlab 2016b or later.')
                    strtemp.tracking.args = [];
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
            if(strcmpi(ext,'.mat'))
                fid             = [pth strip(strip(data{i,match.Audio_file},'left','.'),'left',filesep)];
                disp('Loading spectrogram...');
                strtemp.audio   = load(fid);
                disp('Done!');
                
            elseif(~isempty(ls([pth strip(strip(strrep(data{i,match.Audio_file},ext,'_spectrogram.mat'),'left','.'),'left',filesep)])))
                disp('Loading spectrogram...');
                fid             = [pth strip(strip(strrep(data{i,match.Audio_file},ext,'_spectrogram.mat'),'left','.'),'left',filesep)];
                strtemp.audio   = load(fid);
                
            else
                disp(['Processing file ' data{i,match.Audio_file}]);
                disp('Reading audio...');
                fid             = [pth strip(strip(data{i,match.Audio_file},'left','.'),'left',filesep)];
                [y,fs]          = audioread(fid);
                disp('Generating spectrogram...');
                win = hann(1024);
                [~,f,t,psd]     = spectrogram(y,win,[],[],fs,'yaxis');
                psd             = 10*log10(abs(double(psd)+eps));
                disp('Saving spectrogram for future use...');
                fid             = [pth strip(strip(strrep(data{i,match.Audio_file},ext,'_spectrogram.mat'),'left','.'),'left',filesep)];
                save(fid,'-v7.3','f','t','psd','fs');
                disp('Done!');
                strtemp.audio.f   = f;
                strtemp.audio.t   = t;
                strtemp.audio.psd = psd;
                strtemp.audio.fs  = fs;
            end
            strtemp.audio.psd = imresize(strtemp.audio.psd,0.5);
            strtemp.audio.psd = strtemp.audio.psd(2:end-1,:);
            strtemp.audio.f   = strtemp.audio.f(3:2:end-1);
            strtemp.audio.t   = strtemp.audio.t(2:2:end);
            strtemp.audio.FR  = 1/(strtemp.audio.t(2)-strtemp.audio.t(1));
            
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
    if(enabled.annot(1) && ~isempty(data{i,match.Annotation_file}))
        annoList = strsplit(data{i,match.Annotation_file},';'); tmin = []; tmax = [];
        for j = 1:length(annoList)
            annoList{j} = strtrim(strip(strip(annoList{j},'left','.'),'left',filesep));
            if(j>1), suff = ['_file' num2str(j)]; else suff=''; end
            if(~isempty(strfind(annoList{j}(end-4:end),'xls'))) %old .annot format
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
                    try
                    [atemp,tmin(j),tmax(j)] = loadAnnotSheetTxt([pth annoList{j}]);
                    catch
                        keyboard
                    end
                end
            elseif(strcmpi(annoList{j}(end-2:end),'csv')) %temporary MUPET support
                strtemp.io.annot.fid{j} = [pth annoList{j}];
                M = dlmread([pth annoList{j}],',',1,0);
                dt = strtemp.audio.t(2) - strtemp.audio.t(1);
                atemp.singing.sing = round(M(:,2:3)/dt * 1.0000356445); % what's up, MUPET :\
                tmin(j) = 1;
                tmax(j) = length(strtemp.audio.t);
            else %load data in the old format, OR ETHOVISION, prepare to convert to sheet format when saved
                if(raw{1,9})
                    frame_suffix            = ['_' num2str(data{i,match.Start_Anno}) '-' num2str(data{i,match.Stop_Anno}) '.annot'];
                    strtemp.io.annot.fid{j} = strrep([pth annoList{j}],'.txt',frame_suffix);
                    [atemp,~]               = loadAnnotFile([pth annoList{j}],data{i,match.Start_Anno},data{i,match.Stop_Anno});
                    tmin(j) = data{i,match.Start_Anno};
                    tmax(j) = data{i,match.Stop_Anno};
                else
                    strtemp.io.annot.fid{j} = strrep([pth annoList{j}],'.txt','.annot');
                    [atemp,tmax(j)] = loadAnnotFile([pth annoList{j}]);
                    tmin(j) = 1;
                end
            end
%             atemp  = rmBlankChannels(atemp);
            fields = fieldnames(atemp);
            if(j==1)
                strtemp.annot = struct();
            end
            for f = 1:length(fields)
                strtemp.annot.([fields{f} suff]) = atemp.(fields{f});
            end
        end
        strtemp.annot   = orderfields(strtemp.annot);
        tmin = min(tmin);
        tmax = max(tmax);
        
        if(isnan(tmax))
            tmin = strtemp.io.movie.tmin;
            tmax = strtemp.io.movie.tmax;
        end
        strtemp.io.annot.tmin = tmin;
        strtemp.io.annot.tmax = tmax;
        strtemp.annoTime = (1:(tmax-tmin))/strtemp.annoFR;
        
    elseif(enabled.movie(1) && ~isempty(data{i,match.Behavior_movie}))
        strtemp.io.annot = struct();
        strtemp.io.annot.fid   = [];
        strtemp.io.annot.tmin = strtemp.io.movie.tmin;
        strtemp.io.annot.tmax = strtemp.io.movie.tmax;
        strtemp.io.annoFR   = strtemp.io.movie.FR;
        strtemp.annot = struct();
        strtemp.annoTime = (strtemp.io.annot.tmin:strtemp.io.annot.tmax)/strtemp.io.annoFR;
        
    elseif(enabled.audio(1) && ~isempty(data{i,match.Audio_file}))
        strtemp.io.annot = struct();
        strtemp.io.annot.fid   = [];
        strtemp.io.annot.tmin = strtemp.audio.tmin;
        strtemp.io.annot.tmax = strtemp.audio.tmax;
        strtemp.annoFR   = 1/(strtemp.audio.t(2) - strtemp.audio.t(1));
        strtemp.annot = struct();
        strtemp.annoTime = strtemp.io.annot.tmin:(1/strtemp.annoFR):strtemp.io.annot.tmax;
    
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