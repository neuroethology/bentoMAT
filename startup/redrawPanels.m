function gui = redrawPanels(gui)
% this gets called when the user makes a change to the data being viewed-
% eg, opens a movie, adds tracking data, etc. It is terrible.
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
    if(gui.enabled.(enabled{i})(2))
        gui.(enabled{i}).panel.Visible = 'on';
    else
        gui.(enabled{i}).panel.Visible = 'off';
    end
end

leftOn  = gui.enabled.movie(2)|gui.enabled.audio(2)|gui.enabled.fineAnnot(2);
rightOn = gui.enabled.traces(2)|gui.enabled.features(2);

if(leftOn && rightOn)
    leftWidth = config.midline;
elseif(rightOn)
    leftWidth = 0;
else
    leftWidth = 1;
end
rightStart = leftWidth;
rightWidth = 1-leftWidth;
    
%time for the world's shittiest panel layout code!
if(leftOn)
    if(gui.enabled.movie(2))
        if(gui.enabled.ctrl(2))
            gui.ctrl.panel.Position = [0 0 leftWidth ctrlSize];
            if(gui.enabled.audio(2))
                gui.movie.panel.Position = [0 ctrlSize+.25 leftWidth 1-.25-ctrlSize];
                gui.audio.panel.Position = [0 ctrlSize leftWidth .25];
                gui.fineAnnot.panel.Visible='off'; % merge fineAnnot with audio if both are turned on
            elseif(gui.enabled.fineAnnot(2))
                gui.movie.panel.Position = [0 ctrlSize+.25 leftWidth 1-.25-ctrlSize];
                gui.fineAnnot.panel.Position = [0 ctrlSize leftWidth .25];
            else
                gui.movie.panel.Position = [0 ctrlSize leftWidth 1-ctrlSize];
            end
        else
            if(gui.enabled.audio(2))
                gui.movie.panel.Position = [0 .25 leftWidth 1-.25];
                gui.audio.panel.Position = [0 0 leftWidth .25];
                gui.fineAnnot.panel.Visible='off';
            elseif(gui.enabled.fineAnnot(2))
                gui.movie.panel.Position = [0 .25 leftWidth 1-.25];
                gui.fineAnnot.panel.Position = [0 0 leftWidth .25];
            else
                gui.movie.panel.Position = [0 0 leftWidth 1];
            end
        end
    elseif(gui.enabled.ctrl(2))
        gui.ctrl.panel.Position = [0 0 leftWidth ctrlSize];
        if(gui.enabled.audio(2))
            gui.audio.panel.Position = [0 ctrlSize leftWidth 1-ctrlSize];
            gui.fineAnnot.panel.Visible='off';
        elseif(gui.enabled.fineAnnot(2))
            gui.fineAnnot.panel.Position = [0 ctrlSize leftWidth 1-ctrlSize];
        else
            gui.ctrl.panel.Position = [0 0 leftWidth 1];
        end
    elseif(gui.enabled.audio(2))
        
        if(gui.enabled.ctrl(2))
            gui.ctrl.panel.Position = [0 0 leftWidth ctrlSize];
            gui.audio.panel.Position = [0 ctrlSize leftWidth 1-ctrlSize];
            gui.fineAnnot.panel.Visible='off';
        else
            gui.audio.panel.Position = [0 0 leftWidth 1];
            gui.fineAnnot.panel.Visible='off';
        end
    else %only fineAnnot is on
        if(gui.enabled.ctrl(2))
            gui.ctrl.panel.Position = [0 0 leftWidth ctrlSize];
            gui.fineAnnot.panel.Position = [0 ctrlSize leftWidth 1-ctrlSize];
        else
            gui.fineAnnot.panel.Position = [0 0 leftWidth 1];
        end
    end
end
if(rightOn)
    if(~leftOn && gui.enabled.ctrl(2))
        gui.ctrl.panel.Position = [0 0 1 ctrlSize];
        if(gui.enabled.traces(2))
            if(gui.enabled.features(2))
                gui.traces.panel.Position =   [0 .5+ctrlSize 1 .5-ctrlSize/2];
                gui.features.panel.Position = [0    ctrlSize 1 .5-ctrlSize/2];
            else
                gui.traces.panel.Position = [0 ctrlSize 1 1-ctrlSize];
            end
        else
            gui.features.panel.Position = [0 ctrlSize 1 1-ctrlSize];
        end
    else
        if(gui.enabled.traces(2))
            if(gui.enabled.features(2))
                gui.traces.panel.Position = [rightStart .5 rightWidth .5];
                gui.features.panel.Position = [rightStart 0 rightWidth .5];
            else
                gui.traces.panel.Position = [rightStart 0 rightWidth 1];
            end
        else
            gui.features.panel.Position = [rightStart 0 rightWidth 1];
        end
    end
end
