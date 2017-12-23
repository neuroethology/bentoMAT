function changeExpt(source,~)
useSource = source.Parent.Parent.Parent;
gui = guidata(useSource);

mList    = get(gui.ctrl.expt.mouse,'String');
sessList = get(gui.ctrl.expt.session,'String');
trList   = get(gui.ctrl.expt.trial,'String');

m       = str2num(mList{get(gui.ctrl.expt.mouse,'Value')});
sess    = ['session' sessList{get(gui.ctrl.expt.session,'Value')}];
tr      = str2num(trList{get(gui.ctrl.expt.trial,'Value')});

% determine whether we have to load a new seq movie (loading takes a while)
if(~gui.enabled.movie(1))
    newMovie = false;
elseif(~strcmpi(source.Tag,'trial'))
    newMovie = true;
else
    len = [length(gui.data.io.movie.fid) length(gui.allData(m).(sess)(tr).io.movie.fid)];
    newMovie = len(1)~=len(2);
    for i = 1:min(len)
        newMovie = newMovie | ~strcmpi(gui.data.io.movie.fid{i}, ...
                                       gui.allData(m).(sess)(tr).io.movie.fid{i});
    end
end
gui = setActiveMouse(gui,m,sess,tr,newMovie);
gui = redrawPanels(gui);

guidata(useSource,gui);
dummy.Source.Tag = 'slider';
updatePlot(gui.h0,dummy);