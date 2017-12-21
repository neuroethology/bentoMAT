function tableCallback(source,eventdata)

if(isempty(eventdata.Indices))
    return;
end

gui=guidata(source);
m       = str2num(source.Data{eventdata.Indices(1),1});
sess    = ['session' source.Data{eventdata.Indices(1),2}];
tr      = getTrial(eventdata.Indices(1),source.Data);

switch eventdata.Indices(2)
    case 5  %edit entry
        expt.Mouse = m;
        expt.Sess = sess(8:end);
        expt.Trial = num2str(tr);
        expt.Stim = source.Data{eventdata.Indices(1),3};
        entryWindow(gui,eventdata.Indices(1),gui.mouse(m).(sess)(tr).io,expt);
        
    case 6  %duplicate entry        
        newMouse = gui.mouse(m).(sess)([1:tr tr]);
        newdata  = source.Data([1:eventdata.Indices(1) eventdata.Indices(1)],:);
        
        if(eventdata.Indices(1)<size(source.Data,1))
            newdata  = [newdata; source.Data(eventdata.Indices(1)+1:end,:)];
            newMouse = [newMouse gui.mouse(m).(sess)(tr+1:end)];
        end
        source.Data = newdata;
        gui.mouse(m).(sess) = newMouse;
        guidata(gui.f,gui);
        
    case 7  %delete entry
        if(eventdata.Indices(1)==1 && size(source.Data,1)==1)
            return;
        end
        source.Data(eventdata.Indices(1),:)=[];
        
        gui.mouse(m).(sess)(tr) = [];
        guidata(gui.f,gui);
end
gui.preview.String = getIODataString(gui.mouse(m).(sess)(tr).io);

