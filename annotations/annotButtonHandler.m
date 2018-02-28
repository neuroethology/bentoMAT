function annotButtonHandler(source,~)
    gui    = guidata(source);

    switch source.Tag
        case 'add channel'
            newStr   = addNewFieldPopup('Name of new channel:');
            gui      = addChannel(gui, newStr);

        case 'add behavior'
            if(isempty(gui.annot.channels)) % check if we need to add a channel first
                newStr  = addNewFieldPopup('Please name a channel to which this behavior will be added:');
                gui     = addChannel(gui,newStr);
            end
            % now add the behavior itself
            newStr   = addNewFieldPopup('Name of new annotation:');
            gui      = addLabel(gui,newStr);

        case 'remove channel'
            toDelete = removeFieldPopup(gui,'channel');
            gui      = rmChannel(gui,toDelete);
            
        case 'remove behavior'
            toDelete = removeFieldPopup(gui,'behavior');
            gui      = rmLabel(gui,toDelete);
            
    end

    gui.enabled.annot        = [1 1]; % enable annots if they haven't been already
    gui.enabled.legend       = [1 1];
    gui.enabled.fineAnnot(1) = 1; % don't display fineAnnot by default?
    gui = redrawPanels(gui);
    
    updateSliderAnnot(gui);
    resetAnnotText(gui);
    updateLegend(gui,1);
    guidata(gui.h0,gui);
    updatePlot(gui.h0,[]);
end

function newStr = addNewFieldPopup(prompt)
    newStr  = inputdlg(prompt);
    if(isempty(newStr))
        return;
    end
    
    % make sure that the new name is legit
    newStr = newStr{1};
    newStr(ismember(newStr,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
    newStr = strrep(newStr,' ','_');
    if(isempty(newStr))
        uiwait(msgbox('Name must be at least one character long.'));
    end
end

function toDelete = removeFieldPopup(gui,fieldname)
    switch fieldname
        case 'channel'
            labels  = gui.annot.channels;
        case 'behavior'
            labels  = fieldnames(gui.annot.bhv);
    end

    prompt = [fieldname ' to delete:'];
    toDelete = listdlg('PromptString',prompt,'ListString',labels);
    toDelete = labels(toDelete);
end