function changeExpt(source,~)
useSource = source.Parent.Parent.Parent;
gui = guidata(useSource);

mList    = get(gui.ctrl.expt.mouse,'String');
sessList = get(gui.ctrl.expt.session,'String');
trList   = get(gui.ctrl.expt.trial,'String');

m       = str2num(mList{get(gui.ctrl.expt.mouse,'Value')});
sess    = ['session' sessList{get(gui.ctrl.expt.session,'Value')}];
tr      = str2num(trList{get(gui.ctrl.expt.trial,'Value')});

% determine whether we have to load a new seq movie (loading can take a while)
if(~gui.enabled.movie(1)) % movies aren't enabled
    newMovie = false;
    
elseif(~isfield(gui.allData(m).(sess)(tr).io.movie,'fid')) % new trial doesn't have a movie
    newMovie = false;
    set(gui.movie.img,'cdata',32*ones(1,1,3)); %blank screen
    
else % new trial has a movie- now check if it's the same
    if(~strcmpi(source.Tag,'trial')) %diffent mouse or session -> always assume a new movie
        newMovie = true;
    else
        len = [length(gui.data.io.movie.fid) length(gui.allData(m).(sess)(tr).io.movie.fid)];
        newMovie = len(1)~=len(2);  %check if the number of movies is the same
        for i = 1:min(len)          %check if the identity of each movie is the same
            newMovie = newMovie | ~strcmpi(gui.data.io.movie.fid{i}, ...
                                           gui.allData(m).(sess)(tr).io.movie.fid{i});
        end
    end
end
gui = setActiveMouse(gui,m,sess,tr,newMovie);
gui = redrawPanels(gui);

guidata(useSource,gui);
dummy.Source.Tag = 'slider';
updatePlot(gui.h0,dummy);