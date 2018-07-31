function [annot,tmin,tmax,FR] = loadAnnotSheetTxt(fname,tmin,tmax)

% in case a Bento user doesn't want to load all frames of the annotations,
% we let Bento pass tmin/tmax values:
if(nargin<2)
    tmin = nan;
    tmax = nan;
elseif(isstr(tmin))
    tmin = str2num(tmin);
    tmax = str2num(tmax);
end

% read file line-by-line into a cell array
fid     = fopen(fname);
tline   = fgetl(fid);
M       = {};
while ischar(tline)
    M{end+1} = tline;
    tline = fgetl(fid);
end
fclose(fid);
M{end+1}='';

% if tmin/tmax weren't set by the user, read them out from the file
if(isnan(tmin))
    L = find(~cellfun(@isempty,strfind(M,'Annotation start frame:')));
    tmin = str2num(M{L}(25:end));
    L = find(~cellfun(@isempty,strfind(M,'Annotation stop frame:')));
    tmax = str2num(M{L}(24:end));
    L = find(~cellfun(@isempty,strfind(M,'Annotation framerate:')));
    if(~isempty(L))
        FR = str2num(strtrim(M{L}(22:end)));
    else
        FR = nan;
    end
end

% get the channel list/annotation list (starts at "list of channels"/
% "annotations" and ends at the first blank line.)
start = find(strcmpi(M,'List of channels:'))+1;
stop = find(strcmpi(M(start:end),''),1,'first')+start-2;
channels = M(start:stop);

start = find(strcmpi(M,'List of annotations:'))+1;
stop = find(strcmpi(M(start:end),''),1,'first')+start-2;
labels = M(start:stop);

% initialize the struct that gets returned to Bento
annot = struct();
for c = channels
    for f = labels
        annot.(c{:}).(f{:}) = [];
    end
end

% annotations for each channel are delimited by that channel's name
% followed by a couple dashes- so this finds all channels with data.
chInds = find(~cellfun(@isempty,strfind(M,'----------')));
if(isempty(chInds))
    return;
end
if(chInds(end)~=length(M))
    chInds = [chInds length(M)];
end

% loop over channels until everything's read.
% individual behavior annotations are always prefaced by a blank line,
% which is how I find the start of a new behavior's annotations-
% alternatively you could search for ">" characters at the start of lines
for c = 1:length(chInds)-1
    ch = M{chInds(c)}(1:end-10); % active channel
    beh    = M{chInds(c)+1}(2:end);  %active behavior
    L = chInds(c)+3;
    while L<chInds(c+1)+1
        if(isempty(M{L}))   % blank line == we've reached the end of one behavior
            beh = M{L+1}(2:end);
            L=L+3;          % skip the next two lines (behavior name + start/stop/duration headers)
        else
            vals = str2num(M{L});
            if(vals(2)>=tmin && vals(1)<=tmax)
                annot.(ch).(beh)(end+1,:) = min(max(vals(1:2)-tmin+1,0),tmax-tmin+1);
            end
            L=L+1; % go to the next line
        end
    end
end









