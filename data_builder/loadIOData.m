function [data,enabled] = loadIOData(io,prev)
% load and organize files associated with a data entry

keyboard
data = io;
for f = fieldnames(io)'
    if(~(exist(io.(f{:}))==2)) %it's a piece of metadata
        if(~isempty(str2num(data.(f{:}))))
            data.(f{:}) = str2num(data.(f{:}));
        end
    else %it's a data file to be loaded
        if(~isempty(prev) && isfield(pref,f{:}) && strcmpi(data.(f{:}),prev.(f{:}))) %file is same as in prev
            
        else % it's a new file, time to load it
            [pth,fname,ext] = fileparts(io.(f{:}));
        end
    end
end
keyboard