function setFeatThreshold(source,~,tag)

gui = guidata(source);

featInd = strcmpi({gui.features.feat.tag},tag);
lim     = get(gui.features.feat(featInd).axes,'ylim');
newThr  = source.Value*(lim(2)-lim(1));
lim     = lim(gui.features.feat(featInd).thrBound);

set(gui.features.feat(featInd).threshLine,'xdata',gui.features.win*[-1 1 1 -1],...
        'ydata',[lim lim newThr newThr]);


% display effects of thresholding as annotations throughout the movie
if(strcmpi(gui.annot.activeCh,'thresholded_features'))
    
    mask = getThresholdedFeatureMask(gui);

    % and display them
    gui.annot.bhv.unsaved_feature = mask;
    updateSliderAnnot(gui);
    guidata(gui.h0,gui);
    updatePlot(gui.h0,[]);
end




