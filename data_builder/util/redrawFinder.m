function redrawFinder(source,~)

gui = guidata(source);
res   = get(source,'position');
set(gui.tCa,'columnwidth',{.93*350});