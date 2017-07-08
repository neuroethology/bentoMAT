function quickSave(source,~)
gui = guidata(source);

m    = gui.data.info.mouse;
sess = gui.data.info.session;
tr   = gui.data.info.trial;
gui     = readoutAnnot(gui);
gui.allData(m).(sess)(tr).annot = gui.data.annot;

saveAnnotSheetTxt(gui,gui.data,m,sess,tr); %save the file too just to be safe
gui.annot.modified = 0;

guidata(source,gui);