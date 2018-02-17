function saveFeatThresholds(source,~)

gui = guidata(source);

[mask,params] = getThresholdedFeatureMask(gui);

if(~isfield(gui.features,'savedFilters'))
    gui.features.savedFilters = params;
else
    gui.features.savedFilters(end+1) = params;
end

if(strcmpi(gui.annot.activeCh,'thresholded_features'))
    str     = ['feature_filter_' num2str(length(gui.features.savedFilters))];
    prompt  = ['Name of new annotation:'];
    newStr  = inputdlg(prompt,'',1,{str});
    if(isempty(newStr))
        return;
    end
    newStr  = [newStr{:}];
    labels  = fieldnames(gui.annot.bhv);
    labels = strrep(labels,'_',' ');
    
    guidata(gui.h0,gui);
    addLabel(labels,newStr,gui.ctrl.annot.annot);
    gui.ctrl.annot.annot.Value = 1;
    gui = guidata(gui.h0);
    newStr(ismember(newStr,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
    gui.annot.bhv.(newStr) = mask;
end

guidata(gui.h0,gui);