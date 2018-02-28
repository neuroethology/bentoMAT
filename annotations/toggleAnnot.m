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
            elseif(isfield(gui.annot.hotkeys,lastKey))
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
        for f = fieldnames(gui.annot.Box)'
            gui.annot.Box.(f{:}).Visible = 'on';
            uistack(gui.annot.Box.(f{:}),'up');
            set(gui.annot.Box.(f{:}),'Ydata',kron(get(gui.(f{:}).axes,'ylim'), [1 1]));
            set(gui.annot.Box.(f{:}),'Xdata',[0 0 0 0]);

            %set box color
            if(any(strcmpi(key,{'delete','backspace'})))
                set(gui.annot.Box.(f{:}),'FaceColor',[.8 .8 .8]);
            else
                str = gui.annot.hotkeys.(key);
                set(gui.annot.Box.(f{:}),'FaceColor',gui.annot.cmap.(str)/3+2/3);
            end
        end
        
    else
        for f = fieldnames(gui.annot.Box)'
            gui.annot.Box.(f{:}).Visible = 'off';
            uistack(gui.annot.Box.(f{:}),'bottom');
            set(gui.annot.Box.(f{:}),'Ydata',[0 0 0 0]);
            set(gui.annot.Box.(f{:}),'FaceColor',[.8 .8 .8])
        end
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