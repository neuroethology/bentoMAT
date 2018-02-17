function flipFeatThreshold(source,~,tag)

gui=guidata(source);
featNum = strcmpi({gui.features.feat.tag},tag);

gui.features.feat(featNum).thrBound = 3-gui.features.feat(featNum).thrBound;

guidata(gui.h0,gui);
setFeatThreshold(gui.features.feat(featNum).threshold,[],tag);