function [data,populated] = getAllFilesFromSheet(pth)

[~,sheets] = xlsfinfo(pth);
[~,~,raw] = xlsread(pth,sheets{1}); %load the excel sheet

% fix nans/filename formatting 
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'/',filesep);
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'\',filesep);
raw(cell2mat(cellfun(@(x) all(isnan(x)),raw,'uniformoutput',false))) = {''};

% get the parent directory
pth = raw{1,1};
if(pth(end)~=filesep)
    pth = [pth filesep];
end

[dataTable,matches,~] = reconcileSheetFormats([],raw);

for i=1:size(dataTable,1)
    dat  = dataTable(i,:);
    populated(i,:) = [dat{1:3}];
    
    m    = dat{1};
    sess = ['session' num2str(dat{2})];
    tr   = dat{3};
    
    temp = struct();
    
    if(~isempty(dat{matches.Annotation_file}))
        temp.io.annot.fid = strcat(pth,strsplit(dat{matches.Annotation_file},';'));
    else
        temp.io.annot=[];
    end
    if(~isempty(dat{matches.Behavior_movie}))
        temp.io.movie.fid = strcat(pth,strsplit(dat{matches.Behavior_movie},';'));
    else
        temp.io.movie = [];
    end
    if(~isempty(dat{matches.Tracking}))
        temp.io.feat.fid  = strcat(pth,strsplit(dat{matches.Tracking},';'));
    else
        temp.io.feat = [];
    end
    
    if(~isempty(dat{matches.Audio_file})) %if there's a spectrogram, check for a feature file as well
        temp.io.audio.fid = strcat(pth,strsplit(dat{matches.Audio_file},';'));
        
        %this code adds a framerate to the feature file (which i forgot to
        %do in the code to generate feature files...)
        m = matfile(temp.io.audio.fid{1});
        FR = 1/(m.t(1,2)-m.t(1,1));
        
        tryFeats = dir(strrep(temp.io.audio.fid{1},'spectrogram.mat','raw_feat*'));
        if(~isempty(tryFeats))
            if(isempty(temp.io.feat))
                temp.io.feat.fid{1} = [tryFeats(1).folder filesep tryFeats(1).name];
            else
                temp.io.feat.fid{end+1} = [tryFeats(1).folder filesep tryFeats(1).name];
            end
            
            %this is the rest of the code to add the framerate~
            m = matfile(temp.io.feat.fid{end},'Writable',true);
            if(~any(strcmpi(fieldnames(m),'FR')))
                m.FR = FR;
            end
            
        end
    end
    
    if(~isempty(temp.io.annot))
        for fid = 1:length(temp.io.annot.fid)
            atemp = loadAnyAnnot(temp.io.annot.fid{fid});
            fields = fieldnames(atemp);
            if(fid==1)
                temp.annot = atemp;
            else
                for f = 1:length(fields)
                    temp.annot.([fields{f} '_file' num2str(f)]) = atemp.(fields{f});
                end
            end
        end
    end
    
    data(m).(sess)(tr) = temp;
end