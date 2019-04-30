function selectMovie(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(strcmpi(class(source),'matlab.ui.Figure'))
    useSource = source;
else
    useSource = source.Parent.Parent;
end
gui = guidata(useSource);
[fname,pathname] = uigetfile([gui.config.root '*.mp4;*.avi;*.seq']);

% prompt to remove traces if they exist:
if(all(gui.enabled.traces))
    ans = questdlg('Keep current Ca traces?','loading new movie...','Yes');
    switch ans
        case 'No'
            gui = drawTraces(gui);
            gui.enabled.traces = [0 0];
        case 'Cancel'
            return;
    end
end

temp.io.movie.fid = [fname pathname];
temp.io.movie.tmin = 0;
temp.io.movie.tmax = inf;
if(strcmpi(fname(end-2:end),'seq'))
	temp.annoFR = prompt('Enter framerate of seq file:');
end
[gui,gui.data] = loadMovie(gui,temp);

% remove existing tracker and annotation data:
gui = drawCtrl(gui);
gui = drawTracker(gui);

% toggle window visiblity
gui.enabled.welcome = [0 0];
gui.enabled.tracker = [0 0];
gui.enabled.movie   = [1 1];
gui.enabled.ctrl    = [1 1];

% update everything
gui = redrawPanels(gui);
guidata(useSource,gui);
updatePlot(useSource,[]);