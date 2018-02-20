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

leftOn  = gui.enabled.movie(2);
rightOn = gui.enabled.traces(2)|gui.enabled.features(2)|gui.enabled.audio(2)|gui.enabled.fineAnnot(2);

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
bump = 0;
if(leftOn)
    
    if(gui.enabled.ctrl(2)) % control panel at the bottom
        gui.ctrl.panel.Position = [0 0 leftWidth ctrlSize];
        bump = ctrlSize;
    end
    
    if(gui.enabled.audio(2)) %then audio/fineAnnot
        gui.audio.panel.Position = [0 bump leftWidth .25];
        gui.fineAnnot.panel.Visible='off'; % merge fineAnnot with audio if both are turned on
        bump=bump+.25;
    elseif(gui.enabled.fineAnnot(2))
        gui.fineAnnot.panel.Position = [0 bump leftWidth .25];
        bump=bump+.25;
    end
    
    gui.movie.panel.Position = [0 bump leftWidth 1-bump]; %remaining space goes to the movie
    
end

bump = 0;
if(rightOn)
    if(~leftOn && (gui.enabled.ctrl(2)||gui.enabled.audio(2)||gui.enabled.fineAnnot(2)))
        
        if(gui.enabled.ctrl(2)) %control panel first
            gui.ctrl.panel.Position = [0 0 1 ctrlSize];
            bump = ctrlSize;
        end
        
        if(gui.enabled.audio(2)) %then audio/fineAnnot if applicable
            gui.audio.panel.Position = [0 bump 1 bump+.2];
            gui.fineAnnot.panel.Visible='off';
            bump = bump+.2;
        elseif(gui.enabled.fineAnnot(2))
            gui.fineAnnot.panel.Position = [0 bump 1 bump+.1];
            bump = bump+.25;
        end
        
        if(gui.enabled.traces(2)) %then divide remaining space between features + traces
            if(gui.enabled.features(2))
                gui.features.panel.Position = [0  bump 1 (1-bump)/2];
                gui.traces.panel.Position =   [0 bump+(1-bump)/2 1 (1-bump)/2];
            else
                gui.traces.panel.Position = [0 bump 1 1-bump];
            end
        else
            gui.features.panel.Position = [0 bump 1 1-bump];
        end
        
    else % don't have to worry about ctrl/audio/fineAnnot placement
        
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
