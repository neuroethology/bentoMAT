function addChannel(channels,newStr,parent)

newStr(ismember(newStr,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
newStr = strrep(newStr,' ','_');

if(isempty(newStr))
    msgbox('Name must be at least one character long.');
    return;
end

%save the new channel name:
channels{end+1}     = newStr;
gui                 = guidata(parent);
gui.annot.channels  = channels;
gui.enabled.annot(1)     = 1; % enable annots if they haven't been already
gui.enabled.fineAnnot(1) = 1;

%intitialize the new channel to be blank in all behaviors
f = fieldnames(gui.annot.bhv);
blank = struct();
for i=1:length(f)
    blank.(f{i}) = [];
    gui.annot.bhv.(f{i})  = false(size(gui.data.annoTime));
    gui.annot.show.(f{i}) = 1;
end

% add the new channel to gui.data
gui.data.annot.(channels{end}) = blank;

%add the new channel to gui.allData
sessionList = fieldnames(gui.allData);
mask = false(1,length(gui.allData));
for i=1:length(sessionList)
    mask = mask|(~cellfun(@isempty,{gui.allData.(sessionList{i})}));
end
mice = find(mask); %find all the mice that contain data
for m = mice
    for s = sessionList'
        for tr = 1:length(gui.allData(m).(s{:}))
            gui.allData(m).(s{:})(tr).annot.(channels{end}) = blank;
        end
    end
end

gui.annot.modified = 1;
updateSliderAnnot(gui);
parent.String = {channels{:},'add new...','remove channel...'};
parent.Value = length(channels);
gui.annot.activeCh = channels{end};

guidata(parent,gui);