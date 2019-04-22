function gui = copyChannel(gui, sourceStr, newStr)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(isempty(newStr))
    return;
end

newCh               = strrep(newStr,' ','_');
sourceCh            = strrep(sourceStr,' ','_');

%save the new channel name:
channels            = gui.annot.channels;
channels{end+1}     = newCh;
channels            = unique(channels); %remove duplicate channel names
gui.annot.channels  = channels;

% copy the channel in gui.data
gui.data.annot.(newCh) = gui.data.annot.(sourceCh);
gui.data.annot = orderfields(gui.data.annot);

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
                gui.allData(m).(s{:})(tr).annot.(newCh) = ...
                    gui.allData(m).(s{:})(tr).annot.(sourceCh);
                gui.allData(m).(s{:})(tr).annot = orderfields(gui.allData(m).(s{:})(tr).annot);
            end
        end
    end
end

gui.ctrl.annot.ch.String = channels;
gui.ctrl.annot.ch.Value  = length(channels);
gui.annot.activeCh       = channels{end};
