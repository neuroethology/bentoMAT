function quickSave(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

m    = gui.data.info.mouse;
sess = gui.data.info.session;
tr   = gui.data.info.trial;
gui     = readoutAnnot(gui);
gui.allData(m).(sess)(tr).annot = gui.data.annot;

trial = gui.allData(m).(sess)(tr);

if(gui.data.io.annot.tmin~=1)
    suggestedName = ['mouse' num2str(m) '_' sess '_' num2str(tr,'%03d') '_' ...
                     num2str(gui.data.io.annot.tmin) '-' num2str(gui.data.io.annot.tmax) '.annot'];
else
    suggestedName = ['mouse' num2str(m) '_' sess '_' num2str(tr,'%03d') '.annot'];
end
if(isfield(trial.io.movie,'fid')) %save the file too
    fname = saveAnnotSheetTxt(trial.io.movie.fid,gui.data,suggestedName,0,gui.annot.saveAsTime);
else
    fname = saveAnnotSheetTxt([],gui.data,suggestedName,0,gui.annot.saveAsTime);
end
    
gui.annot.modified = 0;
gui.allData(m).(sess)(tr).io.annot.fid = {fname}; %update the metadata
gui.data.io.annot.fid = {fname};

guidata(source,gui);