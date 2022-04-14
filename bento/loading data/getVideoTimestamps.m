function timestamps = getVideoTimestamps(video)

    timestamps = [];
    [pth,fid,ext] = fileparts(video);
    [pth2,fid2,~] = fileparts(pth);
    
    camfile_formats = {fullfile(pth2,[fid2 '_logfile.txt']), fullfile(pth,[fid '_logfile.txt']), strrep(video,ext,'.txt')};
    for camfile = camfile_formats
        if exist(camfile{:},'file')
            timestamps = fileread(camfile{:});
            timestamps = split(convertCharsToStrings(timestamps));
            timestamps(cellfun('isempty',timestamps)) = [];
            timestamps = str2double(timestamps);

            dt = median(timestamps(2:end)-timestamps(1:end-1));
            timestamps = timestamps - timestamps(1) + dt;
            break
        end
    end