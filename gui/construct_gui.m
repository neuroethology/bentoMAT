gui = struct();

gui.h0 = figure(20);clf;
set(gui.h0,'dockcontrols','off','menubar','none',...
    'NumberTitle','off','position',[80 123 1000 650],...
    'WindowButtonDownFcn',[],...
    'KeyPressFcn',@evalKeyDown,...
    'KeyReleaseFcn',@evalKeyUp,...
    'WindowButtonUpFcn',@clearAction,...
    'CloseRequestFcn',@closeGui);

% sets which panels are visible/being updated.
gui.enabled.movie    = 0;
gui.enabled.ctrl     = 0;
gui.enabled.traces   = 0;
gui.enabled.tracker  = 0;
gui.enabled.audio    = 0;
gui.enabled.features = 0;
gui.enabled.welcome  = 1;

gui.config  = loadConfig();
gui.menus   = menu_setup(gui);

gui     = drawMovie(gui);
gui     = drawTraces(gui);
gui     = drawFeatures(gui);
gui     = drawAudio(gui);
gui     = drawAnnot(gui);
gui     = drawCtrl(gui);
gui     = drawWelcome(gui);

gui = redrawPanels(gui);

gui.Action      = 0;
gui.quitbutton  = 0;

guidata(gui.h0,gui);
