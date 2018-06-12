function gui = addLabel(gui,newStr)

if(isempty(newStr))
    return;
end
if(isfield(gui.annot.bhv,newStr))
    uiwait(msgbox(['A behavior called ' newStr ' already exists!']));
    return
end


% save the new label:
gui.annot.bhv.(newStr)  = false(size(gui.data.annoTime));
gui.annot.show.(newStr) = 1;
gui.annot.modified      = 1;


% set the new annotation color:
if(any(strcmpi(fieldnames(gui.annot.cmapDef),newStr)))
    newColor = gui.annot.cmapDef.(newStr);
else
    used     = [1 1 1; 0 0 0; .94 .94 .94];
    for f = fieldnames(gui.annot.cmap)'
        used(end+1,:) = gui.annot.cmap.(f{:});
    end
    newColor = distinguishable_colors(1,used)/2+.5;
end
gui.annot.cmap.(newStr)     = newColor;
gui.annot.cmapDef.(newStr)  = newColor;


% set the new hotkey:
if(any(strcmpi(fieldnames(gui.annot.hotkeysDef),newStr)))
    hotkey = gui.annot.hotkeysDef.(newStr);
    if(strcmpi(newStr,'unsaved_feature'))
        hotkey='z';
    end
    gui.annot.hotkeys.(hotkey) = newStr;

elseif(~strcmpi(newStr,'unsaved_feature'))
    hotkey = inputdlg(['Assign hotkey for ' strrep(newStr,'_',' ') '?']);
    if(~isempty(hotkey))
        hotkey = regexprep(hotkey{:},'[^a-zA-z]','');
        if(~isfield(gui.annot.hotkeys,hotkey) && (length(hotkey)==1))
            gui.annot.hotkeys.(hotkey)    = newStr; % add the hotkey to the list
            gui.annot.hotkeysDef.(newStr) = hotkey;
        end
    end
end


% add the new label to current data:
gui.data.annot.(gui.annot.activeCh).(newStr) = [];


% add the new label to gui.allData:
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
