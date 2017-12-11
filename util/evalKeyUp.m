function evalKeyUp(source,eventdata)

gui=guidata(source);
% if(isempty(gui.annot.activeCh))
%     return
% end

switch eventdata.Key
    case 'space'
        if(~gui.Action)
            gui.Action = [gui.ctrl.slider.SliderStep(1) 0];
            guidata(gui.h0,gui);
        else
            clearAction(source);
        end
    case 'rightarrow'
        clearAction(source);
    case 'leftarrow'
        clearAction(source);
end