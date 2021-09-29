function [annot, maxTime] = loadAnnotFileObserver(cleantext, fr)

cleantext = cellfun(@(x) regexprep(x,{'\"','(',')'},''), cleantext, 'uniformoutput',false);

headers = split(cleantext{1},';');
behavior_name_index = find(strcmpi(headers,'behavior'));
event_type_index = find(strcmpi(headers,'event_type'));
timestamp_index = find(strcmpi(headers,'Time_Relative_sf'));

if length([behavior_name_index event_type_index timestamp_index])~=3
    disp('something went wrong- I couldn''t find fields Behavior, Event_Type, and/or Time_Relative_sf.');
    return
end

annot.Ch1=[];
counts=[];
for i=2:length(cleantext)
    if(isempty(strtrim(cleantext{i})))
        continue
    end
    data = split(strtrim(cleantext{i}),';');
    event = data{event_type_index};
    if strcmpi(event,'state start')
        flag = 1;
    elseif strcmpi(event,'state stop')
        flag = 2;
    elseif strcmpi(event,'state point') % not sure what this means.
        continue
    else % does this ever happen??
        flag = 0;
        keyboard
    end
    
    beh = strrep(data{behavior_name_index},' ','_');
    beh = regexprep(beh, '[^\w]', ''); % remove bad characters
    time = ceil(str2num(data{timestamp_index})*fr);
    if ~isfield(annot.Ch1,beh)
        annot.Ch1.(beh) = [];
        counts.(beh) = 0;
    end
    if flag==1
        counts.(beh) = counts.(beh)+1;
    end
    annot.Ch1.(beh)(counts.(beh),flag) = time;
end
maxTime = time;