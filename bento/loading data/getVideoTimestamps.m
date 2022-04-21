function timestamps = getVideoTimestamps(video, suffix)

    if ~exist('suffix','var')
        suffix = '';
    end
    timestamps = [];
    [pth,fid,ext] = fileparts(video);
    [pth2,fid2,~] = fileparts(pth);
    
    camfile_formats = {fullfile(pth2,[fid2 '_logfile.txt']), fullfile(pth,[fid '_logfile.txt']), ...
                       fullfile(pth2,[fid2 suffix '.txt']), fullfile(pth,[fid suffix '.txt']), strrep(video,ext,'.txt')};
    for camfile = camfile_formats
        if exist(camfile{:},'file')
            timestamps = fileread(camfile{:});
            timestamps = split(convertCharsToStrings(timestamps));
            timestamps(cellfun('isempty',timestamps)) = [];
            timestamps = str2double(timestamps);

            dt = median(timestamps(2:end)-timestamps(1:end-1));
            timestamps = timestamps - timestamps(1) + dt;
            return
        end
    end
    
    camfile_formats = {fullfile(pth2,[fid2 '_logfile.csv']), fullfile(pth,[fid '_logfile.csv']), ...
                       fullfile(pth2,[fid2 suffix '.csv']), fullfile(pth,[fid suffix '.csv']), strrep(video,ext,'.csv')};
    for camfile = camfile_formats
        if exist(camfile{:},'file')
            Tbl = readtable(camfile{:});
            if ~any(strcmpi(Tbl.Properties.VariableNames,'TimeStamp_ms_'))
                continue;
            end
            timestamps = Tbl.TimeStamp_ms_/1000;

            dt = median(timestamps(2:end)-timestamps(1:end-1));
%             timestamps = timestamps - timestamps(1) + dt;
            return
        end
    end