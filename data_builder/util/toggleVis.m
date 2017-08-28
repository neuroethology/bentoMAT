function toggleVis(source,~)
gui = guidata(source);

switch(get(source,'Tag'))
    case('concatCa')
        gui.t.Data(:,6:7) = {[]};
        gui.rowVis(6:7) = get(source,'Value');
    case('concatAnnot')
        gui.t.Data(:,11:12) = {[]};
        gui.rowVis(11:12) = get(source,'Value');
    case('FRCa')
        gui.t.Data(:,8) = {[]};
        gui.rowVis(8) = get(source,'Value');
        if(gui.rowVis(8)==0)
            set(gui.CaFR,'Enable','on');
            set(gui.CaFRtxt,'Enable','on');
        else
            set(gui.CaFR,'String','','Enable','off');
            set(gui.CaFRtxt,'Enable','off');
        end
    case('FRAnnot')
        gui.t.Data(:,13) = {[]};
        gui.rowVis(13) = get(source,'Value');
        if(gui.rowVis(13)==0)
            set(gui.annoFR,'Enable','on');
            set(gui.annoFRtxt,'Enable','on');
        else
            set(gui.annoFR,'String','','Enable','off');
            set(gui.annoFRtxt,'Enable','off');
        end
    case('offset')
        gui.rowVis(14) = get(source,'Value');
        gui.t.Data(:,14) = {[]};
    case('BhvMovies')
        gui.rowVis(15) = get(source,'Value');
        gui.t.Data(:,15) = {[]};
    case('Tracking');
        gui.rowVis(16) = get(source,'Value');
        gui.t.Data(:,16) = {[]};
    case('Audio');
        gui.rowVis(17) = get(source,'Value');
        gui.t.Data(:,17) = {[]};
end

guidata(source,gui);
redrawBuilder(get(source,'parent'),[]);