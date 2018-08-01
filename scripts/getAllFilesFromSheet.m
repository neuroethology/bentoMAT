function [data,populated] = getAllFilesFromSheet(pth)

[~,~,raw] = xlsread(pth,'Sheet1'); %load the excel sheet

% fix nans/filename formatting issues
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
    
    temp.io.annot.fid = strcat(pth,strsplit(dat{matches.Annotation_file},';'));
    temp.io.movie.fid = strcat(pth,strsplit(dat{matches.Behavior_movie},';'));
    temp.io.feat.fid  = strcat(pth,strsplit(dat{matches.Tracking},';'));
    
    data(m).(sess)(tr) = temp;
end