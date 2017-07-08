function loadTracking(source,~)
% loads tracking data! Right now just for jellyfish, but hopefully also
% RCPR/Weizhe's setup in the future.

%correct for the fact that multiple gui elements can call this function:
if(strcmpi(class(source),'matlab.ui.Figure')) useSource = source;
else useSource = source.Parent.Parent; end

gui = guidata(useSource);

[fname,pathname] = uigetfile([gui.config.root '*.mat']);

% this part will be replaced with a pop-up asking you to specify what kind
% of tracking data you're using--------------------------------------------
data = load([pathname fname]);
if(~isfield(data,'hull'))
    error('Was expecting a convex-hull tracking file');
end
gui.tracker.data = unpackConvexHull(data);

if(~gui.enabled.movie)
    prompt = {'Enter tracking framerate:'};
    dlg_title = '';
    num_lines = 1;
    def = {'30'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    gui.data.bhvFr      = str2num(answer{:});
    gui = drawCtrl(gui);
    gui.ctrl.slider.Max           = nframes/gui.data.bhvFr;
    gui.ctrl.slider.SliderStep    = [1/gui.data.bhvFr 1];
    gui.ctrl.slider.Value         = 1/gui.data.bhvFr;
    updateSlider(gui.h0,gui.ctrl.slider);
end

set(gui.tracker.zeroLine,'ydata',[-4 4]);
L = gui.tracker.data.L;
cla(cla(gui.ctrl.spectrogram.axes));
temp=gca;
axes(cla(gui.ctrl.spectrogram.axes));
spectrogram(L-nanmean(L),200,[],[],gui.data.bhvFr,'yaxis');
colorbar off;
axis off;
axes(temp);

% add new line object(s) to the movie axes:
gui.tracker.hullPlot  = plot(0,0,'r','parent',gui.movie.axes);
%--------------------------------------------------------------------------

% toggle window visibility
gui.enabled.welcome = 0;
gui.enabled.tracker = 1;
gui.enabled.ctrl    = 1;

% update everything
gui = redrawPanels(gui);
guidata(useSource,gui);
updatePlot(useSource,[]);