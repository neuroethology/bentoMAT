function doQuit(source)
gui = guidata(source);
gui.quitbutton = 1;
guidata(source,gui);