function saveTrackingChanges(source,~)

h    = guidata(source);
gui  = guidata(h.guifig);

[FileName,PathName] = uiputfile();
adjustments = gui.data.tracking.active;
save([PathName FileName],'adjustments');