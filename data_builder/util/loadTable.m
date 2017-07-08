function loadTable(source,~)
gui = guidata(source);

pth = get(gui.root,'string');
if(~strcmpi(pth(end),'\'))
    pth = [pth '\'];
end
[FileName,PathName] = uigetfile([pth '*.xls;*.xlsx']);
if(~FileName)
    return;
end

unpackExptToBuilder(source,[PathName FileName],gui);