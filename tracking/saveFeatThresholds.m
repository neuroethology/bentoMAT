function saveFeatThresholds(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui = guidata(source);

[mask,params] = getThresholdedFeatureMask(gui);

if(~isfield(gui.features,'savedFilters'))
    gui.features.savedFilters{1} = params;
else
    try
    gui.features.savedFilters{end+1} = params;
    catch
        keyboard
    end
end

if(strcmpi(gui.annot.activeCh,'thresholded_features'))
    str     = ['feature_filter_' num2str(length(gui.features.savedFilters))];
    prompt  = ['Name of new annotation:'];
    newStr  = inputdlg(prompt,'',1,{str});
    if(isempty(newStr))
        return;
    end
    newStr  = [newStr{:}];
    newStr  = strrep(newStr,' ','_');
    
    gui = addLabel(gui,newStr);
    gui.ctrl.annot.annot.Value = 1;
    newStr(ismember(newStr,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
    gui.annot.bhv.(newStr) = mask;
end

guidata(gui.h0,gui);
updateLegend(gui,1);