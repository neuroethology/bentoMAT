function addChannel(source,~,channels,textfield,parent)

newStr = textfield.String;
newStr(ismember(newStr,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
newStr = strrep(newStr,' ','_');

if(isempty(newStr))
    msgbox('Name must be at least one character long.');
    return;
end

%save the new channel name:
channels{end+1}     = strrep(newStr,'_',' ');
gui                 = guidata(parent);
gui.annot.channels  = channels;
if(gui.enabled.annot==0)
    gui.enabled.annot = 1;
end

%intitialize the new channel to be blank
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
parent.Value = length(channels)+1;
gui.annot.activeCh = channels{end};

guidata(parent,gui);

close();