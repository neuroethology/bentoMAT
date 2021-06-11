function toDelete = removeFieldPopup(gui,fieldname,action)
    switch fieldname
        case 'channel'
            labels  = gui.annot.channels;
        case 'behavior'
            labels  = fieldnames(gui.annot.bhv);
    end

    prompt = [fieldname ' to ' action ':'];
    toDelete = listdlg('PromptString',prompt,'ListString',labels);
    toDelete = labels(toDelete);
end