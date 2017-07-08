function toggleVis(source,~)
gui = guidata(source);

switch(get(source,'Tag'))
    case('concatCa')
        gui.t.Data(:,6:7) = {[]};
        gui.rowVis(6:7) = get(source,'Value');
    case('concatAnnot')
        gui.t.Data(:,10:11) = {[]};
        gui.rowVis(10:11) = get(source,'Value');
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
        gui.t.Data(:,12) = {[]};
        gui.rowVis(12) = get(source,'Value');
        if(gui.rowVis(12)==0)
            set(gui.annoFR,'Enable','on');
            set(gui.annoFRtxt,'Enable','on');
        else
            set(gui.annoFR,'String','','Enable','off');
            set(gui.annoFRtxt,'Enable','off');
        end
    case('offset')
        gui.rowVis(13) = get(source,'Value');
        gui.t.Data(:,13) = {[]};
    case('BhvMovies')
        gui.rowVis(14) = get(source,'Value');
        gui.t.Data(:,14) = {[]};
end

guidata(source,gui);
redrawBuilder(get(source,'parent'),[]);