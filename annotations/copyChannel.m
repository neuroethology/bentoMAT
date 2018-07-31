function gui = copyChannel(gui, sourceStr, newStr)

if(isempty(newStr))
    return;
end

%save the new channel name:
channels            = gui.annot.channels;
channels{end+1}     = strrep(newStr,' ','_');
channels            = unique(channels); %remove duplicate channel names
sourceCh            = strrep(sourceStr,' ','_');
gui.annot.channels  = channels;

% copy the channel in gui.data
gui.data.annot.(channels{end}) = gui.data.annot.(sourceCh);

% copy the channel in gui.allData
sessionList = fieldnames(gui.allData);
mask = false(1,length(gui.allData));
for i=1:length(sessionList)
    mask = mask|(~cellfun(@isempty,{gui.allData.(sessionList{i})}));
end
mice = find(mask); %find all the mice that contain data

for m = mice
    for s = sessionList'
        for tr = 1:length(gui.allData(m).(s{:}))
            if(isfield(gui.allData(m).(s{:})(tr).annot,sourceCh))
                gui.allData(m).(s{:})(tr).annot.(channels{end}) = ...
                    gui.allData(m).(s{:})(tr).annot.(sourceCh);
            end
        end
    end
end

gui.ctrl.annot.ch.String = channels;
gui.ctrl.annot.ch.Value  = length(channels);
gui.annot.activeCh       = channels{end};
