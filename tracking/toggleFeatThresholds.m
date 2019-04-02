function toggleFeatThresholds(source,~,flag)
% just changes the visibility of a bunch of buttons for when the user is
% playing around with thresholding features

gui = guidata(source);

if(flag)
    str = 'on';
    str2 = 'off';
else
    str = 'off';
    str2 = 'on';
end

gui.features.threshOn.Visible   = str2;
gui.features.threshOff.Visible  = str;
gui.features.threshSave.Visible = str;

for i=1:length(gui.features.feat)
    gui.features.feat(i).thresholdU.Visible  = str;
    gui.features.feat(i).thresholdL.Visible  = str;
    gui.features.feat(i).threshLineU.Visible = str;
    gui.features.feat(i).threshLineL.Visible = str;
    gui.features.feat(i).threshValU.Visible  = str;
    gui.features.feat(i).threshValL.Visible  = str;
end

if(flag) % when switching into threshold mode, also change annotation channels
    if(~any(strcmpi(gui.annot.channels,'thresholded_features')))
        gui = addChannel(gui, 'thresholded_features');
        for f = fieldnames(gui.annot.bhv)' %remove the other behaviors from this channel
            gui.annot.bhv = rmfield(gui.annot.bhv,f{:});
            gui.data.annot.thresholded_features = rmfield(gui.data.annot.thresholded_features,f{:});
        end
        gui.ctrl.annot.annot.Value = 1;
    else
        gui.ctrl.annot.ch.Value = find(strcmpi(gui.annot.channels,'thresholded_features'));
    end
    gui = addLabel(gui, 'unsaved_feature');
else
    gui.annot.bhv = rmfield(gui.annot.bhv,'unsaved_feature');
    guidata(gui.h0,gui);
    updateSliderAnnot(gui);
end

guidata(gui.h0,gui);
updateLegend(gui,1);
updatePlot(gui.h0,[]);


