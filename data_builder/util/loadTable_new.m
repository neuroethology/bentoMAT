function loadTable_new(source,~)
gui = guidata(source);

pth = gui.pth;
if(~strcmpi(pth(end),filesep))
    pth = [pth filesep];
end
[FileName,PathName] = uigetfile([pth '*.mat']);
if(~FileName)
    return;
end

load([PathName FileName]);
gui.pth = PathName;
gui = updateTableData(gui,mouse);
guidata(gui.f,gui);