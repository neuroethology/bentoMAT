function gui = rmLabel(gui,toDelete)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(isempty(toDelete))
    return;
end

% remove label from active annots:
gui.annot.bhv = rmfield(gui.annot.bhv,toDelete);

% remove label from gui.data:
for i=1:length(toDelete)
    if(isfield(gui.data.annot.(gui.annot.activeCh),toDelete{i}))
        gui.data.annot.(gui.annot.activeCh) = rmfield(gui.data.annot.(gui.annot.activeCh),toDelete{i});
    end
end

% remove label from gui.allData (all mice/sessions/trials):
sessionList = fieldnames(gui.allData);
mask        = false(1,length(gui.allData));
for i=1:length(sessionList)
    mask = mask|(~cellfun(@isempty,{gui.allData.(sessionList{i})}));
end
mice = find(mask); %find all the mice that contain data

for m = mice
    for s = sessionList'
        for tr = 1:length(gui.allData(m).(s{:}))
            for i=1:length(toDelete)
                if(isfield(gui.allData(m).(s{:})(tr).annot.(gui.annot.activeCh),toDelete{i}))
                    gui.allData(m).(s{:})(tr).annot.(gui.annot.activeCh) = ...
                        rmfield(gui.allData(m).(s{:})(tr).annot.(gui.annot.activeCh),toDelete{i});
                end
            end
        end
    end
end

resetAnnotText(gui);