function addLabel(labels,newStr,parent)

newStr(ismember(newStr,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
newStr = strrep(newStr,' ','_');

if(isempty(newStr))
    msgbox('Name must be at least one character long.');
    return;
end

%save the new label:
labels{end+1}   = strrep(newStr,'_',' ');

gui = guidata(parent);
cmap        = gui.annot.cmap;
defaults    = gui.annot.cmapDef;
if(any(strcmpi(fieldnames(defaults),newStr)))
    newColor = defaults.(newStr);
else
    used    = [];
    for f = fieldnames(cmap)'
        used(end+1,:) = cmap.(f{:});
    end
    newColor = distinguishable_colors(1,[1 1 1; 0 0 0; used; .94 .94 .94])/2+.5;
end

gui.annot.bhv.(newStr)  = false(size(gui.data.annoTime));
gui.annot.show.(newStr) = 1;
gui.annot.cmap.(newStr) = newColor;
gui.annot.cmapDef.(newStr) = newColor;
gui.annot.modified = 1;

%add the new label to gui.allData:
sessionList = fieldnames(gui.allData);
mask        = false(1,length(gui.allData));
for i=1:length(sessionList)
    mask = mask|(~cellfun(@isempty,{gui.allData.(sessionList{i})}));
end
mice = find(mask); %find all the mice that contain data

for m = mice
    for s = sessionList'
        for tr = 1:length(gui.allData(m).(s{:}))
            gui.allData(m).(s{:})(tr).annot.(gui.annot.activeCh).(newStr) = [];
        end
    end
end

guidata(parent,gui);

parent.String = {labels{:},'add new...','remove label...'};
parent.Value = length(labels);