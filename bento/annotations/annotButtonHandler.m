function annotButtonHandler(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


    gui    = guidata(source);

    switch source.Tag
        case 'add channel'
            newStr   = addNewFieldPopup('Name of new channel:',{''});
            gui      = addChannel(gui, newStr);

        case 'add behavior'
            if(isempty(gui.annot.channels)) % check if we need to add a channel first
                newStr  = addNewFieldPopup('Please name a channel to which this behavior will be added:');
                gui     = addChannel(gui,newStr);
            end
            % now add the behavior itself
            newStr   = addNewFieldPopup('Name of new annotation:',{''});
            gui      = addLabel(gui,newStr);

        case 'remove channel'
            toDelete = removeFieldPopup(gui,'channel','delete');
            gui      = rmChannel(gui,toDelete);
            gui.ctrl.annot.ch.Value = 1;
            
        case 'remove behavior'
            toDelete = removeFieldPopup(gui,'behavior','delete');
            gui      = rmLabel(gui,toDelete);
            
        case 'copy channel'
            toCopy = removeFieldPopup(gui,'channel','copy');
            for i=1:length(toCopy)
                newStr = addNewFieldPopup(['New name for ' toCopy{i} ':'],{[toCopy{i} '_2']});
                gui     = copyChannel(gui,toCopy{i},newStr);
            end
            
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
