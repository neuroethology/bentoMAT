%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


if(~exist('gui','var')|~isstruct(gui))
    gui = struct();
    if(isfield(gui,'data')), gui = rmfield(gui,'data'); end
    if(isfield(gui,'allData')), gui = rmfield(gui,'allData'); end
end

gui.h0 = figure(20);clf;
set(gui.h0,'dockcontrols','off','menubar','none',...
    'NumberTitle','off','position',[80 123 1000 650],...
    'WindowButtonDownFcn',[],...
    'KeyPressFcn',@evalKeyDown,...
    'KeyReleaseFcn',@evalKeyUp,...
    'WindowButtonUpFcn',@clearAction,...
    'CloseRequestFcn',@closeGui);

% sets which panels are visible/being updated.
gui.enabled.movie     = [0 0];
gui.enabled.ctrl      = [0 0];
gui.enabled.annot     = [0 0];
gui.enabled.traces    = [0 0];
gui.enabled.tracker   = [0 0];
gui.enabled.audio     = [0 0];
gui.enabled.features  = [0 0];
gui.enabled.fineAnnot = [0 0];
gui.enabled.legend    = [0 0];
gui.enabled.tsne      = [0 0];
gui.enabled.scatter   = [0 0];
gui.enabled.welcome   = [1 1];

gui.config  = loadConfig();
gui.menus   = menu_setup(gui);

gui     = drawMovie(gui);
gui     = drawTraces(gui);
gui     = drawFeatures(gui);
gui     = drawAudio(gui);
gui     = drawfineAnnot(gui);
gui     = drawAnnot(gui);
gui     = drawCtrl(gui);
gui     = drawLegend(gui);
gui     = drawScatter(gui);
gui     = drawWelcome(gui);

gui = redrawPanels(gui);

gui.Action      = 0;
gui.Keys.Shift  = 0;
gui.Keys.Ctrl   = 0;
gui.Keys.Alt    = 0;
gui.quitbutton  = 0;
gui.ctrl.slider.timer = tic;

guidata(gui.h0,gui);
