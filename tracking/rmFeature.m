function rmFeature(source,~,tag)

gui = guidata(source);

tagList = {gui.features.feat.tag};
featnum = find(strcmpi(tagList,tag));

delete(gui.features.feat(featnum).axes);
delete(gui.features.feat(featnum).rmBtn);
gui.features.feat(featnum) = [];

if(~isempty(gui.features.feat))
    gui = redrawFeaturePlots(gui);
end

guidata(gui.h0,gui);
updatePlot(gui.h0,[]);