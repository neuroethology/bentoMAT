function quickSave(source,~)
gui = guidata(source);

m    = gui.data.info.mouse;
sess = gui.data.info.session;
tr   = gui.data.info.trial;
gui     = readoutAnnot(gui);
gui.allData(m).(sess)(tr).annot = gui.data.annot;

suggestedName = ['mouse' num2str(m) '_' sess '_' num2str(tr,'%03d') '.annot'];
saveAnnotSheetTxt(trial.io.movie.fid,gui.data,suggestedName); %save the file too just to be safe
gui.annot.modified = 0;

guidata(source,gui);