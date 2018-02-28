function gui = toggleAnnot(gui,toggle,key,lastKey)
    
    gui.annot.prev = gui.annot.bhv;
    switch toggle
        case 'start'
            toggleAnnotBoxes(gui,'on',key);
            gui.annot.highlightStart = max(round(...
                (gui.ctrl.slider.Value - gui.ctrl.slider.Min + 1/gui.data.annoFR)*gui.data.annoFR)-1,1);

        case 'switch'
            toggleAnnotBoxes(gui,'on',key);
            inds    = getAnnotInds(gui);
            str     = gui.annot.hotkeys.(lastKey);
            gui.annot.bhv.(str)(inds) = true;
            
            gui.annot.highlightStart = max(round(...
                (gui.ctrl.slider.Value - gui.ctrl.slider.Min + 1/gui.data.annoFR)*gui.data.annoFR)-1,1);
            
        case 'end'
            toggleAnnotBoxes(gui,'off');
            inds    = getAnnotInds(gui);
            if(any(strcmpi(lastKey,{'delete','backspace'}))) %erase everything
                for str = fieldnames(gui.annot.bhv)'
                    gui.annot.bhv.(str{:})(inds) = false;
                end
            else
                str = gui.annot.hotkeys.(lastKey);
                gui.annot.bhv.(str)(inds) = ~any(strcmpi(key,{'delete','backspace'}));
            end
            
            gui.annot.modified = 1;
            gui.annot.highlightStart = [];
            gui.annot.highlighting = 0;
    end
    
end

function toggleAnnotBoxes(gui, toggle, key)
    if(strcmpi(toggle,'on'))
        gui.annot.Box.traces.Visible = 'on';
        uistack(gui.annot.Box.traces,'up');
        set(gui.annot.Box.traces,'Ydata',kron(get(gui.traces.axes,'ylim'), [1 1]));
        set(gui.annot.Box.traces,'Xdata',[0 0 0 0]);
        
        %set box color
        if(any(strcmpi(key,{'delete','backspace'})))
            set(gui.annot.Box.traces,'FaceColor',[.8 .8 .8]);
        else
            str = gui.annot.hotkeys.(key);
            set(gui.annot.Box.traces,'FaceColor',gui.annot.cmap.(str)/3+2/3);
        end
        
    else
        gui.annot.Box.traces.Visible = 'off';
        uistack(gui.annot.Box.traces,'bottom');
        set(gui.annot.Box.traces,'Ydata',[0 0 0 0]);
        set(gui.annot.Box.traces,'FaceColor',[.8 .8 .8])
    end
end

function inds = getAnnotInds(gui)
    p1 = gui.annot.highlightStart;
    p2 = round((gui.ctrl.slider.Value - gui.ctrl.slider.Min)*gui.data.annoFR);
    if(p1<p2)
        inds = p1:p2;
    else
        inds = p2:p1;
    end
end