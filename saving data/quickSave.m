function quickSave(source,~)
gui = guidata(source);

m    = gui.data.info.mouse;
sess = gui.data.info.session;
tr   = gui.data.info.trial;
gui     = readoutAnnot(gui);
gui.allData(m).(sess)(tr).annot = gui.data.annot;

trial = gui.allData(m).(sess)(tr);

suggestedName = ['mouse' num2str(m) '_' sess '_' num2str(tr,'%03d') '.annot'];
if(isfield(trial.io.movie,'fid'))
    saveAnnotSheetTxt(trial.io.movie.fid,gui.data,suggestedName); %save the file too
else
    saveAnnotSheetTxt([],gui.data,suggestedName);
end
    
gui.annot.modified = 0;

guidata(source,gui);