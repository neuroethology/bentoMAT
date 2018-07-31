function launchAnnoChanger(source)

gui=guidata(source);
answer = inputdlg({'Enter new annotation framerate:','Apply to all loaded data? (y/n)'},'Change framerate');

if(isempty(answer))
    return;
end

newFR = str2num(answer{1});
doAll = strcmpi(answer{2},'y');

if(doAll)
    for i = 1:size(gui.allPopulated,1)
        m  = gui.allPopulated(i,1);
        s  = ['session' num2str(gui.allPopulated(i,2))];
        tr = gui.allPopulated(i,3);
        
        gui.allData(m).(s)(tr) = changeAnnoFR(gui.allData(m).(s)(tr),newFR);
    end
end

gui.data    = changeAnnoFR(gui.data,newFR);
info        = gui.data.info;
gui.allData(info.mouse).(info.session)(info.trial) = ...
    changeAnnoFR(gui.allData(info.mouse).(info.session)(info.trial),newFR);

if(gui.enabled.annot(1)) %i should hope it is
    gui = transferAnnot(gui,gui.data);
end

guidata(gui.h0,gui);
end

function data = changeAnnoFR(data,newFR)
    oldFR   = data.annoFR;
    sc = newFR/oldFR;
    dt = 1/newFR;

    % update annoTime
    tStart  = data.annoTime(1)-(1/oldFR);
    tStop   = data.annoTime(end);
    data.annoTime = (tStart+dt):dt:tStop;
    % scale start/stop time of all behavior bouts
    for ch = fieldnames(data.annot)'
        for bhv = fieldnames(data.annot.(ch{:}))'

            data.annot.(ch{:}).(bhv{:}) = round(data.annot.(ch{:}).(bhv{:})*sc);

        end
    end
    % update the annot file FR
    data.io.annot.FR = newFR;
end