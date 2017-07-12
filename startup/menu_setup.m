function mh = menu_setup(gui)

mh.loader = uimenu(gui.h0,'Label','File');
uimenu(mh.loader,'Label','Load experiment','callback',{@loadExpt,'load'});
uimenu(mh.loader,'Label','Edit experiment','callback',{@loadExpt,'edit'});
% uimenu(mh.loader,'Label','Open movie','callback',@selectMovie);
% uimenu(mh.loader,'Label','Open traces','callback',@selectTraces);
% uimenu(mh.loader,'Label','Open tracking data','callback',@loadTracking);
% uimenu(mh.loader,'Label','Open annotations','callback',@selectAnnot);
% 
% uimenu(mh.loader,'Label','Launch tracker','Separator','on','enable','off');
% uimenu(mh.loader,'Label','Open tracking data','enable','off','callback',@loadTracking);
% uimenu(mh.loader,'Label','Save tracking data','enable','off','callback',@saveTracking);
% 
% uimenu(mh.loader,'Label','New annotations','Separator','on','enable','off','callback',@newAnnot);
% uimenu(mh.loader,'Label','Open annotations','enable','off','callback',@loadAnnot);
% uimenu(mh.loader,'Label','Save annotations','enable','off','callback',@saveAnnotFile);
% 
% uimenu(mh.loader,'Label','Save as new experiment','Separator','on','enable','off','callback',@saveNewExpt);
% uimenu(mh.loader,'Label','Save experiment','enable','off','callback',@saveExpt);

uimenu(mh.loader,'Label','Quit','Separator','on','Accelerator','Q','callback',@doQuit);


mh.display = uimenu(gui.h0,'Label','Display');
uimenu(mh.display,'Label','Select traces to show','callback',@pickUnits);
uimenu(mh.display,'Label','Select annotations to show','callback',@pickAnnot);
uimenu(mh.display,'Label','Set annotation colors','callback',@launchColorPick);
uimenu(mh.display,'Label','Sort units by CP','Separator','on','callback',@runCPsort);


mh.analyze = uimenu(gui.h0,'Label','Analysis','enable','off');
uimenu(mh.analyze,'Label','Find similar events','callback',{@(x,y) disp('not implemented yet')});
uimenu(mh.analyze,'Label','Compute BTA','callback',@launchBTA);