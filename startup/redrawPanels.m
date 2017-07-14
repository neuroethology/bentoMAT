function gui = redrawPanels(gui)
% this gets called when the user makes a change to the data being viewed-
% eg, opens a movie, adds tracking data, etc. In the future, there will
% also be a menu option that will let you toggle ui elements on/off.
enabled     = fieldnames(gui.enabled);
config      = gui.config;

ctrlSize = ones(size(gui.config.ctrl));
for i = 1:length(gui.config.ctrl)
    if(isfield(gui.config.ctrlSc,gui.config.ctrl{i}))
        ctrlSize(i) = gui.config.ctrlSc.(gui.config.ctrl{i});
    end
end
ctrlSize = sum(ctrlSize)*gui.config.rowscale;


for i = 1:length(enabled)
    if(gui.enabled.(enabled{i}))
        gui.(enabled{i}).panel.Visible = 'on';
    else
        gui.(enabled{i}).panel.Visible = 'off';
    end
end

if(gui.enabled.movie && (gui.enabled.traces||gui.enabled.features))
    gui.movie.panel.Position  = [0 ctrlSize config.midline 1-ctrlSize];
    gui.ctrl.panel.Position   = [0 0 config.midline ctrlSize];
    if(gui.enabled.traces&&gui.enabled.tracker)
        gui.traces.panel.Position = [config.midline 0 1-config.midline 0.5];
        gui.features.panel.Position = [config.midline 0.5 1-config.midline 1];
    elseif(gui.enabled.traces)
        gui.traces.panel.Position = [config.midline 0 1-config.midline 1];
    else
        gui.features.panel.Position = [config.midline 0 1-config.midline 1];
    end
    
elseif(gui.enabled.movie)
    gui.movie.panel.Position  = [0 ctrlSize 1 1-ctrlSize];
    gui.ctrl.panel.Position   = [0 0 1 ctrlSize];
    
elseif(gui.enabled.traces&&gui.enabled.features)
    gui.traces.panel.Position = [0 ctrlSize 0.5 1-ctrlSize];
    gui.features.panel.Position = [0.5 ctrlSize 1 1-ctrlSize];
    gui.ctrl.panel.Position   = [0 0 1 ctrlSize];
    
elseif(gui.enabled.traces)
    gui.traces.panel.Position = [0 ctrlSize 1 1-ctrlSize];
    gui.ctrl.panel.Position   = [0 0 1 ctrlSize];
    
elseif(gui.enabled.features)
    gui.features.panel.Position = [0 ctrlSize 1 1-ctrlSize];
    gui.ctrl.panel.Position   = [0 0 1 ctrlSize];
    
else
    gui.welcome.panel.Position = [0 0 1 1];
end