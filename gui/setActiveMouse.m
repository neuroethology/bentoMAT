function gui = setActiveMouse(gui,m,sess,tr,newMovie)

% save the data from the current mouse- need a catch if there is no current
% mouse (ie on startup)
if(isfield(gui,'data'))
    mOld    = gui.data.info.mouse;
    sessOld = gui.data.info.session;
    trOld   = gui.data.info.trial;
else
    mOld    = [];
    sessOld = '';
    trOld   = [];
end
if(gui.annot.modified)
    gui     = readoutAnnot(gui); %transfer most recent annotations back to gui.data
    choice  = questdlg('Save annotation changes to file?');
    switch choice
        case 'Cancel'
            mList    = get(gui.ctrl.expt.mouse,'String');
            sessList = get(gui.ctrl.expt.session,'String');
            trList   = get(gui.ctrl.expt.trial,'String');
            
            set(gui.ctrl.expt.mouse,'Value',find(strcmpi(mList,num2str(mOld))));
            set(gui.ctrl.expt.session,'Value',find(strcmpi(sessList,strrep(sessOld,'session',''))));
            set(gui.ctrl.expt.trial,'Value',find(strcmpi(trList,num2str(trOld))));
            return;
        case 'Yes'
            gui.allData(mOld).(sessOld)(trOld).annot = gui.data.annot;
            saveAnnotSheetTxt(gui,gui.data,mOld,sessOld,trOld);
            gui.annot.modified = 0;
        case 'No'
            gui.allData(mOld).(sessOld)(trOld).annot = gui.data.annot;
            gui.annot.modified = 0;
    end
end




%update session list for the new mouse
use = gui.allPopulated(:,1)==m;
if(~any(gui.allPopulated(use,2)==str2double(strrep(sess,'session',''))))
    sess = ['session' num2str(gui.allPopulated(use(1),2))];
    set(gui.ctrl.expt.session,'Value',1);
end
set(gui.ctrl.expt.session,'String',strtrim(cellstr(num2str(unique(gui.allPopulated(use,2))))));

%update trial list for the new session
use = use & (gui.allPopulated(:,2)==str2double(strrep(sess,'session','')));
if(m~=mOld|~strcmpi(sess,sessOld))
    tr = gui.allPopulated(find(use,1,'first'),3);
    set(gui.ctrl.expt.trial,'Value',1);
end
set(gui.ctrl.expt.trial,'String',strtrim(cellstr(num2str(gui.allPopulated(use,3)))));

data                = gui.allData(m).(sess)(tr);
data.info.mouse     = m;
data.info.session   = sess;
data.info.trial     = tr;

% now! load the movie
if(gui.enabled.movie)
    if(newMovie)
        [gui,data]  = loadMovie(gui,data);
    else
        data.io.movie.reader = gui.data.io.movie.reader;
        gui = applySliderUpdates(gui,'movie',data.io.movie);
    end
elseif(gui.enabled.traces)
    gui = applySliderUpdates(gui,'Ca',data);
else
    gui = applySliderUpdates(gui,'audio',data);
end

% get tracking type if needed
if(gui.enabled.tracker)
    if(isfield(gui,'data'))
        data.tracking.fun = gui.data.tracking.fun;
    else
        data.tracking.fun = promptTrackType();
        if(isempty(data.tracking.fun))
            gui.enabled.tracker = 0;
        end
    end
    data.tracking.active    = cell(1,data.io.movie.tmax-data.io.movie.tmin+1); %clear tracking features
    data.tracking.active(1:end) = {1}; %default active settings
    data.tracking.inactive  = cell(1,data.io.movie.tmax-data.io.movie.tmin+1); %clear tracking features
    data.tracking.inactive(1:end) = {2:1e5};
    data.tracking.crop      = [];
end

% tweak the traces
N = size(data.rast,1);
if(isfield(gui,'data') && strcmpi(sess,sessOld) && m==mOld) %inherit show settings from previously used trial
    data.show   = gui.data.show;
    data.order  = gui.data.order;
else
    data.show   = true(N,1);
    data.order  = 1:N;
end
data.rast = [nan(N,1) data.rast nan(N,1)]; % pad with nans for display

gui.data = data;
% add the behavior annotations to the gui
if(gui.enabled.annot)
    gui = transferAnnot(gui,data);
    set(gui.audio.bg,'visible','on');
    updateSliderAnnot(gui);
end
