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