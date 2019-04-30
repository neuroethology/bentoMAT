function rmFeature(source,~,tag)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui = guidata(source);

tagList = {gui.features.feat.tag};
featnum = find(strcmpi(tagList,tag));

delete(gui.features.feat(featnum).axes);
delete(gui.features.feat(featnum).rmBtn);
delete(gui.features.feat(featnum).thresholdU);
delete(gui.features.feat(featnum).thresholdL);
delete(gui.features.feat(featnum).threshValU);
delete(gui.features.feat(featnum).threshValL);
gui.features.feat(featnum) = [];

if(~isempty(gui.features.feat))
    gui = redrawFeaturePlots(gui);
end

guidata(gui.h0,gui);
updatePlot(gui.h0,[]);