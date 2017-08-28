function [annot,tmin,tmax] = loadAnnotSheetTxt(fname,tmin,tmax)
% still need to add support for multiple annotations per file
if(nargin<2)
    tmin = nan;
    tmax = nan;
elseif(isstr(tmin))
    tmin = str2num(tmin);
    tmax = str2num(tmax);
end

fid     = fopen(fname);
tline   = fgetl(fid);
M       = {};
while ischar(tline)
    M{end+1} = tline;
    tline = fgetl(fid);
end
fclose(fid);
M{end+1}='';

if(isnan(tmin))
    L = find(~cellfun(@isempty,strfind(M,'Annotation start frame:')));
    tmin = str2num(M{L}(25:end));
    L = find(~cellfun(@isempty,strfind(M,'Annotation stop frame:')));
    tmax = str2num(M{L}(24:end));
end

start = find(strcmpi(M,'List of channels:'))+1;
stop = find(strcmpi(M(start:end),''),1,'first')+start-2;
channels = M(start:stop);

start = find(strcmpi(M,'List of annotations:'))+1;
stop = find(strcmpi(M(start:end),''),1,'first')+start-2;
labels = M(start:stop);

annot = struct();
for c = channels
    for f = labels
        annot.(c{:}).(f{:}) = [];
    end
end


chInds = find(~cellfun(@isempty,strfind(M,'----------')));
if(isempty(chInds))
    return;
end
if(chInds(end)~=length(M))
    chInds = [chInds length(M)];
end

for c = 1:length(chInds)-1
    ch = M{chInds(c)}(1:end-10); % active channel
    beh    = M{chInds(c)+1}(2:end);  %active behavior
    L = chInds(c)+3;
    while L<chInds(c+1)+1
        if(isempty(M{L}))
            beh = M{L+1}(2:end);
            L=L+3;
        else
            vals = str2num(M{L});
            annot.(ch).(beh)(end+1,:) = vals(1:2);
            L=L+1;
        end
    end
end









