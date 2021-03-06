function Manager_applyLabelChanges(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


h = guidata(source);
gui = h.gui;

data    = gui.allData;
inds    = gui.allPopulated;

mpre=0; spre='';
for i = 1:size(inds,1)
    m       = inds(i,1);
    if(m~=mpre)
        disp(' ');
        disp(['Mouse ' num2str(m)]);
        mpre = m;
    end
    sess    = ['session' num2str(inds(i,2))];
    if(~strcmpi(sess,spre))
        disp(['session ' sess(end) '----------']);
        spre=sess;
    end
    trial   = inds(i,3);
    disp(['Trial ' num2str(trial)]);
    
    dat     = data(m).(sess)(trial);
	suggestedName = ['mouse' num2str(m) '_' sess '_' num2str(trial,'%03d') '.annot'];
    saveAnnotSheetTxt(gui.data.io.movie.fid,dat,suggestedName,0,gui.annot.saveAsTime);
end
gui = setActiveMouse(gui,m,sess,trial,0);
guidata(gui.h0,gui);