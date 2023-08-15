function [annot, maxTime] = loadAnnotSheetDeepSqueak(M, defaultFR)

headers = M(1,:);
label_index = find(strcmpi(headers,'Label'));
accepted_index = find(strcmpi(headers,'Accepted'));
time_start = find(strcmpi(headers,'Begin Time (s)'));
time_stop = find(strcmpi(headers,'End Time (s)'));

if length([label_index accepted_index time_start time_stop])~=4
    disp('something went wrong- I couldn''t find fields Label, Accepted, Begin Time, and/or End Time.');
    return
end

annot.Ch1 = [];
tstop = 0;
for i=2:length(M)
    if (isstr(M{i,accepted_index}) && ~strcmpi(M{i,accepted_index},'TRUE')) || ~M{i,accepted_index}
        continue;
    end

    beh = strrep(M{i, label_index},' ','_');
    beh = regexprep(beh, '[^\w]', ''); % remove bad characters
    if ~isfield(annot.Ch1,beh)
        annot.Ch1.(beh) = [];
    end
    tstart = ceil(M{i, time_start}*defaultFR);
    tstop = ceil(M{i, time_stop}*defaultFR);
    annot.Ch1.(beh)(end+1,:) = [tstart tstop];
end
maxTime = tstop;











