function timestamps = getVideoTimestamps(video)

    timestamps = [];
    [pth,fid,~] = fileparts(video);
    
    camfile = fullfile(pth,[fid '_logfile.txt']);
    if exist(camfile,'file')
        timestamps = fileread(camfile);
        timestamps = split(convertCharsToStrings(timestamps));
        timestamps(cellfun('isempty',timestamps)) = [];
        timestamps = str2double(timestamps);

        dt = median(timestamps(2:end)-timestamps(1:end-1));
        timestamps = timestamps - timestamps(1) + dt;
    end