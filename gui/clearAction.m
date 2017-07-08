function clearAction(source,~)

gui = guidata(source);
gui.Action = 0;
guidata(source,gui);