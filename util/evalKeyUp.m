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
    case 'pagedown'
        clearAction(source);
    case 'pageup'
        clearAction(source);
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
        guidata(gui.h0,gui);
    case 'control'
        gui.Keys.Ctrl = 0;
        guidata(gui.h0,gui);
    case 'h'
        openHelpMenu();
    case 'v'
        toggleEnabled(source);
    case 'n'
        pickAnnot(source,[]);
end
if(gui.enabled.annot(2))
    switch eventdata.Key
        case 'a'
            if(~isempty(gui.annot.activeCh))
                gui.ctrl.annot.toggleAnnot.Value = ~gui.ctrl.annot.toggleAnnot.Value;
                toggleAnnot(gui.ctrl.annot.toggleAnnot);
            end
        case 's'
            if(~isempty(gui.annot.activeCh))
                quickSave(gui.ctrl.annot.save); % quickSave actually saves to file too.... fix this
            end
        case 'e'
            if(~isempty(gui.annot.activeCh))
                gui.ctrl.annot.toggleErase.Value = ~gui.ctrl.annot.toggleErase.Value;
                toggleAnnot(gui.ctrl.annot.toggleErase);
            end
        case 'z'
            if(gui.Keys.Ctrl && gui.annot.modified)
                str     = strrep(gui.ctrl.annot.annot.String{gui.ctrl.annot.annot.Value},' ','_');
                temp    = gui.annot.bhv;
                gui.annot.bhv  = gui.annot.prev;
                gui.annot.prev = temp;
                updateSliderAnnot(gui);
                guidata(gui.h0,gui);
                updatePlot(gui.h0,[]);
            end
        case 't'
            gui.ctrl.annot.annot.Value = mod(gui.ctrl.annot.annot.Value-2, length(gui.ctrl.annot.annot.String)-2) + 1;
        case 'g'
            gui.ctrl.annot.annot.Value = mod(gui.ctrl.annot.annot.Value, length(gui.ctrl.annot.annot.String)-2) + 1;
        case {'f','b'} % jump to next bout of a behavior
            if(~isempty(gui.annot.activeCh))
                str     = strrep(gui.ctrl.annot.annot.String{gui.ctrl.annot.annot.Value},' ','_');
                start   = round((gui.ctrl.slider.Value - gui.ctrl.slider.Min + 1/gui.data.annoFR)*gui.data.annoFR);
                if(start==1) start=2; end
                if(eventdata.Key=='b')
                        jumpFun = @(s) 1 + find(gui.annot.bhv.(s)(2:start-2) & ~gui.annot.bhv.(s)(1:start-3),1,'last');
                else
                        jumpFun = @(s) start - 1 + find(gui.annot.bhv.(s)(start:end) & ~gui.annot.bhv.(s)(start-1:end-1),1,'first');
                end
                ind=inf*(2*(eventdata.Key=='f')-1);
                if(~gui.Keys.Shift)
                    for f = fieldnames(gui.annot.bhv)'
                        i2 = jumpFun(f{:});
                        if(isempty(i2))
                            continue;
                        end
                        if(((eventdata.Key=='f' && i2<ind) || (eventdata.Key=='b' && i2>ind)) && gui.annot.show.(f{:})==1)
                            indNum  = find(strcmpi(fieldnames(gui.annot.bhv),f{:}));
                            ind     = i2;
                        end
                    end
                    if(isinf(ind)) ind = []; end
                else
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
            end
    end
end