function closeGui(source,~)
data = guidata(source);

data.quitbutton = 1;
guidata(source,data);
set(source,'CloseRequestFcn','closereq');
