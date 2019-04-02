function setFeatThreshold(source,~,tag)

gui = guidata(source);

featInd = strcmpi({gui.features.feat.tag},tag);
lim     = get(gui.features.feat(featInd).axes,'ylim');
switch source.Style
    case 'slider'
        newThr  = source.Value*(lim(2)-lim(1)) + lim(1);
        gui.features.feat(featInd).(['threshVal' source.Tag]).String = num2str(newThr);
    case 'edit'
        newThr = str2num(source.String);
        if(newThr<lim(1))
            newThr = lim(1);
            source.String = num2str(lim(1));
        elseif(newThr>lim(2))
            newThr = lim(2);
            source.String = num2str(lim(2));
        end
        
        gui.features.feat(featInd).(['threshold' source.Tag]).Value = ...
            (newThr-lim(1))/(lim(2)-lim(1));
end
set(gui.features.feat(featInd).(['threshVal' source.Tag]),'String',num2str(newThr));

updateThresholdBoxes(gui,featInd);

% display effects of thresholding as annotations throughout the movie
if(strcmpi(gui.annot.activeCh,'thresholded_features'))
    
    mask = getThresholdedFeatureMask(gui);

    % and display them
    gui.annot.bhv.unsaved_feature = mask;
    updateSliderAnnot(gui);
    guidata(gui.h0,gui);
    updatePlot(gui.h0,[]);
end




