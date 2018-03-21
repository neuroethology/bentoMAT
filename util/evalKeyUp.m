function evalKeyUp(source,eventdata)

gui=guidata(source);
switch eventdata.Key
    case 'space'
        if(~gui.Action)
            gui.Action = [gui.ctrl.slider.SliderStep(1) 0];
            guidata(gui.h0,gui);
        else
            clearAction(source);
        end
    case 'uparrow'
        if(isnumeric(gui.Action))
            gui.Action = gui.Action*2;
            guidata(gui.h0,gui);
        end
    case 'downarrow'
        if(isnumeric(gui.Action))
            gui.Action = gui.Action/2;
            guidata(gui.h0,gui);
        end
    case 'rightarrow'
        clearAction(source);
    case 'leftarrow'
        clearAction(source);
    case 'shift'
        gui.Keys.Shift = 0;
        if(any(gui.Action))
            gui.Action(1) = gui.ctrl.slider.SliderStep(1);
        end
        guidata(gui.h0,gui);
    case 'control'
        gui.Keys.Ctrl = 0;
        guidata(gui.h0,gui);
    case {'pagedown','pageup'} % jump to next bout of a behavior
        if(gui.enabled.annot(2) && ~isempty(gui.annot.activeCh))
            str     = gui.annot.activeBeh;
            start   = round((gui.ctrl.slider.Value - gui.ctrl.slider.Min + 1/gui.data.annoFR)*gui.data.annoFR);
            if(start==1) start=2; end
            if(strcmpi(eventdata.Key,'pageup'))
                    jumpFun = @(s) 1 + find(gui.annot.bhv.(s)(2:start-2) & ~gui.annot.bhv.(s)(1:start-3),1,'last');
            else
                    jumpFun = @(s) start - 1 + find(gui.annot.bhv.(s)(start:end) & ~gui.annot.bhv.(s)(start-1:end-1),1,'first');
            end
            ind=inf*(2*strcmpi(eventdata.Key,'pagedown')-1);
            if(~gui.Keys.Shift)
                for f = fieldnames(gui.annot.bhv)'
                    i2 = jumpFun(f{:});
                    if(isempty(i2))
                        continue;
                    end
                    if(((strcmpi(eventdata.Key,'pagedown') && i2<ind) || ...
                        (strcmpi(eventdata.Key,'pageup') && i2>ind)) && gui.annot.show.(f{:})==1)
                        indNum  = find(strcmpi(fieldnames(gui.annot.bhv),f{:}));
                        ind     = i2;
                    end
                end
                if(isinf(ind)) ind = []; end
            elseif(~isempty(str))
                ind = jumpFun(str);
                indNum = find(strcmpi(fieldnames(gui.annot.bhv),str));
            end
            if(~isempty(ind))
                if(strcmpi(gui.ctrl.slider.text.Tag,'timeBox')) set(gui.ctrl.slider.text,'String',makeTime(ind/gui.data.annoFR));
                else set(gui.ctrl.slider.text,'String',num2str(ind)); end
                gui.ctrl.annot.annot.Value = indNum;
                dummy = struct();
                dummy.Source = gui.ctrl.slider.text;
                updatePlot(gui.h0,dummy);
            end
        else
            clearAction(source);
        end
    otherwise % parsing keypresses for annotation
        if(gui.enabled.annot(2))
            if(isempty(gui.annot.activeCh))
                return;
            end
            gui2=guidata(source);
            lastKey = gui.annot.highlighting;
            
            if(any(strcmpi(eventdata.Key,{'delete','backspace'})) || isfield(gui.annot.hotkeys,eventdata.Key))
                gui.annot.highlighting = eventdata.Key;

                if(all(lastKey==0))
                    gui2 = toggleAnnot(gui,'start',eventdata.Key);

                elseif(strcmpi(lastKey,eventdata.Key) || any(strcmpi(eventdata.Key,{'delete','backspace'})))
                    gui2 = toggleAnnot(gui,'end',eventdata.Key,lastKey);

                else
                    gui2 = toggleAnnot(gui,'switch',eventdata.Key,lastKey);
                end
            end
            if(strcmpi(eventdata.Key,'return') && ~isempty(lastKey) && ~isempty(gui.annot.highlightStart))
                gui2 = toggleAnnot(gui,'end',eventdata.Key,lastKey);
            end
            
            gui.annot = gui2.annot;
            updateSliderAnnot(gui);
            guidata(gui.h0,gui);
            updatePlot(gui.h0,[]);
        end
end

% special functions performed by Ctrl+Hotkey
if(gui.Keys.Ctrl)
    switch eventdata.Key
        case 'z'
            if(gui.annot.modified)
                temp    = gui.annot.bhv;
                gui.annot.bhv  = gui.annot.prev;
                gui.annot.prev = temp;
                updateSliderAnnot(gui);
                guidata(gui.h0,gui);
                updatePlot(gui.h0,[]);
            end
    end
end












