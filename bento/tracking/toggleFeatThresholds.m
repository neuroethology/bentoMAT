function toggleFeatThresholds(source,~,flag)
% just changes the visibility of a bunch of buttons for when the user is
% playing around with thresholding features
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



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
    
    channels            = gui.annot.channels;
    channels{end+1}     = strrep('thresholded_features',' ','_');
    gui.annot.channels  = channels;

    gui.annot.bhv = struct('unsaved_feature', false(size(gui.data.annoTime)));
    gui.annot.show = struct('unsaved_feature',1);

    gui.ctrl.annot.ch.String = channels;
    gui.ctrl.annot.ch.Value  = length(channels);
    gui.annot.activeCh       = channels{end};

    gui.ctrl.annot.annot.Value = 1;

    % set annotation color:
    newColor = distinguishable_colors(1,[1 1 1; 0 0 0; .94 .94 .94])/2+.5;
    gui.annot.cmap.unsaved_feature     = newColor;
    gui.annot.cmapDef.unsaved_feature  = newColor;

    % set hotkey:
    gui.annot.hotkeysDef.unsaved_feature = 'z';
    gui.annot.hotkeys.unsaved_feature = 'z';
    
    gui.enabled.legend       = [1 1];
    gui.enabled.fineAnnot(1) = 1; % don't display fineAnnot by default
    gui = redrawPanels(gui);
    gui = redrawFeaturePlots(gui);
else
    %remove the temporary annotation label
    gui.annot.bhv = rmfield(gui.annot.bhv,'unsaved_feature');
    
    % remove the temporary channel
%     if(isfield(gui.data.annot,'thresholded_features'))
%         gui.data.annot = rmfield(gui.data.annot,'thresholded_features');
%     end
    gui.annot.channels  = setdiff(gui.annot.channels,'thresholded_features');
    gui.ctrl.annot.ch.String = gui.annot.channels;
    gui.ctrl.annot.ch.Value  = length(gui.annot.channels);
    gui.annot.activeCh       = [];
    gui = transferAnnot(gui,gui.data);

    guidata(gui.h0,gui);
    updateSliderAnnot(gui);
end

guidata(gui.h0,gui);
updateLegend(gui,1);
updatePlot(gui.h0,[]);


