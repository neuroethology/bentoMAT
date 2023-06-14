function transferExptToGui(data,gui)
% data is either the path to an excel file, or is already the contents of
% that excel file (if those contents were already loaded using the data
% builder gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(iscell(data))
    raw = data;
    if(isempty(raw{1,1}))
        raw{1,1} = uigetdir(pwd,'Please provide the path to your data''s parent directory!');
    end
else
    if ismac | isunix
        raw   = readcell(data);
        raw(cellfun(@(x) any(ismissing(x)), raw)) = {NaN};
    elseif ispc
        [~,~,raw]   = xlsread(data,'Sheet 1');
    end
    
    if(isempty(raw{1,1})|isnan(raw{1,1}))
        pth = fileparts(data);
        raw{1,1} = [pth filesep]; %blank path means read from the directory the sheet is in
    end
end
[mouse,enabled,pth,hotkeys] = unpackExperiment(raw);
gui.pth = pth;
gui.annot = mergeHotkeys(gui.annot,hotkeys);

% toggle window visiblity
gui.enabled         = enabled;
gui.enabled.welcome = [0 0];
gui.enabled.ctrl    = [1 1];

gui.traces.toPlot = 'rast'; %plot cells to start

if(isfield(gui,'data')), gui = rmfield(gui,'data'); end
gui.allData         = mouse;                %stores all mice!
gui.allPopulated    = cell2mat(raw(3:end,1:3)); %keeps a list of which mouse/sess/trials are populated
mouseList           = unique(gui.allPopulated(:,1));
use                 = gui.allPopulated(:,1) == mouseList(1);
guidata(gui.h0,gui); % just in case it crashes after this

% set the active mouse/session/trial
sessList    = cellstr(num2str(unique(gui.allPopulated(use,2))));
trialList   = strtrim(cellstr(num2str(unique(gui.allPopulated(use,3)))));
gui         = setActiveMouse(gui,mouseList(1),['session' sessList{1}],str2num(trialList{1}),1);

% update the control bar that lets us browse through mice, sesions, and
% trials:
set(gui.ctrl.expt.mouse,   'String',cellstr(num2str(mouseList)));
set(gui.ctrl.expt.session, 'Enable','on','String',sessList);
set(gui.ctrl.expt.trial,   'Enable','on','String',trialList);

% update everything
gui = redrawPanels(gui);
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);