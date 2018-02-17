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
    gui.features.feat(i).threshold.Visible  = str;
    gui.features.feat(i).flipThr.Visible    = str;
    gui.features.feat(i).threshLine.Visible = str;
end

if(flag) % when switching into threshold mode, also change annotation channels
    if(~any(strcmpi(gui.annot.channels,'thresholded_features')))
        addChannel(gui.annot.channels, 'thresholded_features', gui.ctrl.annot.ch);
        gui=guidata(gui.h0);
        for f = fieldnames(gui.annot.bhv)'
            gui.annot.bhv = rmfield(gui.annot.bhv,f{:});
        end
        gui.ctrl.annot.annot.Value = 1;
        guidata(gui.h0,gui);
        labels = {};
    else
        gui.ctrl.annot.ch.Value = find(strcmpi(gui.annot.channels,'thresholded_features'));
        updateFields(gui.ctrl.annot.ch,[],'channel');
        labels = fieldnames(gui.data.annot.thresholded_features);
    end
    addLabel(labels, 'unsaved_feature', gui.ctrl.annot.annot);
else
    gui.annot.bhv = rmfield(gui.annot.bhv,'unsaved_feature');
    gui.ctrl.annot.annot.String(strcmpi(gui.ctrl.annot.annot.String,'unsaved_feature')) = [];
    guidata(gui.h0,gui);
    updateSliderAnnot(gui);
end

updatePlot(gui.h0,[]);


