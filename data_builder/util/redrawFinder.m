function redrawFinder(source,~)

gui = guidata(source);
res   = get(source,'position');
set(gui.tCa,'columnwidth',{res(3)*.98-23});