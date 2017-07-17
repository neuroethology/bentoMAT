function mh = menu_setup(gui)

mh.loader = uimenu(gui.h0,'Label','File');
uimenu(mh.loader,'Label','Load experiment','callback',{@loadExpt,'load'});
uimenu(mh.loader,'Label','Edit experiment','callback',{@loadExpt,'edit'});
uimenu(mh.loader,'Label','Manage annotations','Separator','on','callback',@launchAnnotEditor);
uimenu(mh.loader,'Label','Manage tracking data','Separator','on','callback',@launchTrackingCleanup);
uimenu(mh.loader,'Label','Quit','Separator','on','Accelerator','Q','callback',@doQuit);


mh.display = uimenu(gui.h0,'Label','Display');
uimenu(mh.display,'Label','Select traces to show','callback',@pickUnits);
uimenu(mh.display,'Label','Select annotations to show','callback',@pickAnnot);
uimenu(mh.display,'Label','Set annotation colors','callback',@launchColorPick);
uimenu(mh.display,'Label','Sort units by CP','Separator','on','callback',@runCPsort);



% mh.analyze = uimenu(gui.h0,'Label','Analysis','enable','off');
% uimenu(mh.analyze,'Label','Find similar events','callback',{@(x,y) disp('not implemented yet')});
% uimenu(mh.analyze,'Label','Compute BTA','callback',@launchBTA);