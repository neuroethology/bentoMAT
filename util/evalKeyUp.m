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
    case 'rightarrow'
        clearAction(source);
    case 'leftarrow'
        clearAction(source);
    case 'a'
        if(~isempty(gui.annot.activeCh))
            gui.ctrl.annot.toggleAnnot.Value = ~gui.ctrl.annot.toggleAnnot.Value;
            toggleAnnot(gui.ctrl.annot.toggleAnnot);
        end
    case 's'
        if(~isempty(gui.annot.activeCh))
            % save annotations!
        end
    case 'e'
        if(~isempty(gui.annot.activeCh))
            gui.ctrl.annot.toggleErase.Value = ~gui.ctrl.annot.toggleErase.Value;
            toggleAnnot(gui.ctrl.annot.toggleErase);
        end
    case 't'
        if(~isempty(gui.annot.activeCh))
            quickSave(gui.ctrl.annot.save);
        end
end