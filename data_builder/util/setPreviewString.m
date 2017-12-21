function setPreviewString(source,~)

gui=guidata(source);
set(source,'string',gui.previewStr);