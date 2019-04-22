function tracking_editLabels(source,~,type)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



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
        if(s1<=length(gui.data.tracking.active{fr}))
            v1 = gui.data.tracking.active{fr}(s1);
            A1=1;
        else
            s1 = s1-length(gui.data.tracking.active{fr});
            v1 = gui.data.tracking.inactive{fr}(s1);
            A1=0;
        end
        if(s2<=length(gui.data.tracking.active{fr}))
            v2 = gui.data.tracking.active{fr}(s2);
            A2=1;
        else
            s2 = s2-length(gui.data.tracking.active{fr});
            v2 = gui.data.tracking.inactive{fr}(s2);
            A2=0;
        end
        if(A1&&A2)
            gui.data.tracking.active{fr}(s1)=v2;
            gui.data.tracking.active{fr}(s2)=v1;
        elseif(A1)
            gui.data.tracking.active{fr}(s1)=v2;
            gui.data.tracking.inactive{fr}(s2)=v1;
        elseif(A2)
            gui.data.tracking.inactive{fr}(s1)=v2;
            gui.data.tracking.active{fr}(s2)=v1;
        else
            gui.data.tracking.inactive{fr}(s1)=v2;
            gui.data.tracking.inactive{fr}(s2)=v1;
        end
        
        gui.data.tracking.active(fr+1:end) = gui.data.tracking.active(fr);
        gui.data.tracking.inactive(fr+1:end) = gui.data.tracking.inactive(fr);
        
        guidata(gui.h0,gui);
        updatePlot(gui.h0,[]);
    case 'add'
        
end