function transferExptToGui(data,gui)
% data is either the path to an excel file, or is already the contents of
% that excel file (if those contents were already loaded using the data
% builder gui)

if(iscell(data))
    raw = data;
else
    [~,~,raw]   = xlsread(data,'Sheet1');
end
[mouse,enabled] = unpackExperiment(raw);
% toggle window visiblity
gui.enabled.welcome = 0;
gui.enabled.traces  = enabled.traces;
gui.enabled.movie   = enabled.movie;
gui.enabled.ctrl    = 1;
gui.enabled.annot   = enabled.annot;
gui.enabled.tracker = enabled.tracker;

gui.toPlot          = 'rast'; %plot cells to start
set(gui.ctrl.track.plotType,'Value',1);

if(isfield(gui,'data')) gui = rmfield(gui,'data'); end
gui.allData         = mouse;                %stores all mice!
gui.allPopulated    = cell2mat(raw(3:end,1:3)); %keeps a list of which mouse/sess/trials are populated
mouseList           = unique(gui.allPopulated(:,1));
use                 = gui.allPopulated(:,1) == mouseList(1);

% set the active mouse/session/trial
sessList    = cellstr(num2str(unique(gui.allPopulated(use,2))));
trialList   = strtrim(cellstr(num2str(unique(gui.allPopulated(use,3)))));
gui         = setActiveMouse(gui,mouseList(1),['session' sessList{1}],1,1);

% update the control bar that lets us browse through mice, sesions, and
% trials:
set(gui.ctrl.expt.mouse,   'String',cellstr(num2str(mouseList)));
set(gui.ctrl.expt.session, 'Enable','on','String',sessList);
set(gui.ctrl.expt.trial,   'Enable','on','String',trialList);

% update everything
gui = redrawPanels(gui);
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);