function [annot, maxTime] = loadAnnotSheetObserver(M, defaultFR)

headers = M(1,:);
behavior_name_index = find(strcmpi(headers,'behavior'));
event_type_index = find(strcmpi(headers,'event_type'));
timestamp_index = find(strcmpi(headers,'Time_Relative_sf'));

if length([behavior_name_index event_type_index timestamp_index])~=3
    disp('something went wrong- I couldn''t find fields Behavior, Event_Type, and/or Time_Relative_sf.');
    return
end

annot.Ch1 = [];
counts=[];
for i=2:length(M)
    event = M{i,event_type_index};
    if isnan(event)
        continue;
    end
    if strcmpi(event,'state start')
        flag = 1;
    elseif strcmpi(event,'state stop')
        flag = 2;
    elseif strcmpi(event,'state point') % start==stop
        continue
    else % does this ever happen??
        flag = 0;
        keyboard
    end
    
    beh = strrep(M{i, behavior_name_index},' ','_');
    beh = regexprep(beh, '[^\w]', ''); % remove bad characters
    time = ceil(M{i, timestamp_index}*defaultFR);
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











