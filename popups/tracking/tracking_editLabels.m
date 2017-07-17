function tracking_editLabels(source,~,type)

h    = guidata(source);
gui  = guidata(h.guifig);
time = gui.ctrl.slider.Value;
fr   = floor(time*gui.data.annoFR)+1;

switch type
    case 'swap'
        s1  = str2num(h.swap1.String);
        s2  = str2num(h.swap2.String);
        if(isempty(s1)|isempty(s2))
            errordlg('Please specify both objects to swap');
            return;
        end
        ind1 = find(gui.data.tracking.active{fr}==s1);
        ind2 = find(gui.data.tracking.active{fr}==s2);
        if(~isempty(ind1)&~isempty(ind2))
            gui.data.tracking.active{fr}(ind1) = s2;
            gui.data.tracking.active{fr}(ind2) = s1;
        elseif(~isempty(ind1))
            gui.data.tracking.active{fr}(ind1) = s2;
        elseif(~isempty(ind2))
            gui.data.tracking.active{fr}(ind1) = s1;
        end
        gui.data.tracking.active(fr+1:end) = gui.data.tracking.active(fr);
        
        guidata(gui.h0,gui);
        updatePlot(gui.h0,[]);
    case 'add'
        
end