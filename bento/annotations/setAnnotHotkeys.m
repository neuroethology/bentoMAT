function setAnnotHotkeys(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


    gui = guidata(source);
    bhvList = fieldnames(gui.annot.bhv);
    keyList = cell(size(bhvList));
    
    for k = fieldnames(gui.annot.hotkeys)'
        ind = find(strcmpi(gui.annot.hotkeys.(k{:}),bhvList));
        if(~isempty(ind))
            keyList(ind) = k;
        end
    end
    keyList(cellfun(@isempty,keyList)) = {''};
	keyStruct = gui.annot.hotkeys;
    
    flag = 2;
    while(flag)
        if(flag==1)
            msgbox('Please use a distinct, single letter for each behavior');
        end
        newKeys   = inputdlg(strrep(bhvList,'_',' '),'Assign hotkeys to behaviors',1,keyList);
        if(~isempty(newKeys))
            [keyStruct,flag] = assembleKeyStruct(newKeys,bhvList);
        else
            flag=0;
        end
    end
    
    gui.annot.hotkeys = keyStruct;
    for f = fieldnames(keyStruct)'
        gui.annot.hotkeysDef.(keyStruct.(f{:})) = f{:};
    end
    updateLegend(gui,1);
    updatePreferredCmap(gui.annot.cmapDef,gui.annot.hotkeysDef);
    guidata(gui.h0,gui);
end

function [keyStruct,flag]  = assembleKeyStruct(keyList,bhvList)
    flag        = 0;
    keyStruct   = struct();
    keyList     = lower(regexprep(keyList,'[^a-zA-Z]',''));
    
    %look for bad hotkeys
    for i = 1:length(keyList)
        flag = flag | isfield(keyStruct,keyList{i}) | (length(keyList{i})>1);
    end
    
    if(flag)
        return;
    else
        for i = 1:length(keyList)
            if(~isempty(keyList{i}))
                keyStruct.(keyList{i}) = bhvList{i};
            end
        end
    end
    
end