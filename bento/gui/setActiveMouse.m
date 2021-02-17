function gui = setActiveMouse(gui,m,sess,tr,newMovie)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



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
			suggestedName = ['mouse' num2str(mOld) '_' sessOld '_' num2str(trOld,'%03d') '.annot'];
            saveAnnotSheetTxt(gui.data.io.movie.fid,gui.data,suggestedName);
            gui.annot.modified = 0;
        case 'No'
            gui.allData(mOld).(sessOld)(trOld).annot = gui.data.annot;
            gui.annot.modified = 0;
    end
end




%update session list for the new mouse
use = gui.allPopulated(:,1)==m;
set(gui.ctrl.expt.session,'String',strtrim(cellstr(num2str(unique(gui.allPopulated(use,2))))));

%update trial list for the new session
use2 = use & (gui.allPopulated(:,2)==str2double(strrep(sess,'session','')));

if(m~=mOld | ~strcmpi(sess,sessOld)) % if we changed mice or sessions, jump to the first trial
    tr = gui.allPopulated(find(use2,1,'first'),3);
    set(gui.ctrl.expt.trial,'Value',1);
end
set(gui.ctrl.expt.trial,'String',strtrim(cellstr(num2str(gui.allPopulated(use2,3)))));

data                = gui.allData(m).(sess)(tr);
data.info.mouse     = m;
data.info.session   = sess;
data.info.trial     = tr;

%preserve axes of projection (if any)
if(isfield(gui,'data'))
    data.proj           = gui.data.proj;
end

% now! load the movie
if(gui.enabled.movie(1)) 
    if(newMovie || (isfield(gui,'data') && any(size(data.io.movie.fid)~=size(gui.data.io.movie.reader))))
        [gui,data]  = loadMovie(gui,data); 
    else
        data.io.movie.reader     = gui.data.io.movie.reader;
        gui = applySliderUpdates(gui,'movie',data.io.movie);
    end
elseif(gui.enabled.traces(1))
    gui = applySliderUpdates(gui,'Ca',data);
else
    gui = applySliderUpdates(gui,'annot',data);
end

if(gui.enabled.audio(1)) %audio overrides other fields for setting slider resolution
    gui = applySliderUpdates(gui,'audio',data);
end

% get tracking type if needed
if(gui.enabled.tracker(1))
    
    [gui,data] = loadCurrentFeatures(gui,data);

    if(~isfield(data.tracking,'features') || isempty(data.tracking.features))
        gui.enabled.features = [0 0];
    end
    gui = redrawPanels(gui);
    
    if(isfield(data.io.movie,'tmax') && isfield(data.io.movie,'FR'))
        nFrames = round((data.io.movie.tmax-data.io.movie.tmin)*data.io.movie.FR) + 1;
    elseif(isfield(data.tracking,'features'))
        nFrames = length(data.tracking.features);
    else
        f = fieldnames(data.tracking.args{1});
        nFrames = length(data.tracking.args{1}.(f{1}));
    end
    data.tracking.active    = cell(1,nFrames); %clear tracking features
    data.tracking.inactive  = cell(1,nFrames);
    data.tracking.active(1:end) = {1}; %default active settings
    data.tracking.inactive(1:end) = {2:1e5};
    data.tracking.crop      = [];
end

% tweak the traces
N = size(data.rast,1);
if ~(isfield(gui,'data') && strcmpi(sess,sessOld) && m==mOld) %inherit show settings from previously used trial
    gui.traces.show   = true(N,1);
    gui.traces.order  = (1:N)/N;
end
data.rast = [nan(N,1) data.rast nan(N,1)]; % pad with nans for display
if(isfield(gui,'data') && isfield(gui.data,'PCA') && size(gui.data.rast,1)==N)
    data.PCA = gui.data.PCA;
end

gui.data = data;
% add the behavior annotations to the gui
if(gui.enabled.annot(1))
    gui = transferAnnot(gui,data);
	if(gui.enabled.annot(2))
		set(gui.audio.bg,'visible','on');
		updateSliderAnnot(gui);
		end
end
% clean out the annotations
resetAnnotText(gui);
% update the legend
updateLegend(gui,1);
% update the scatterplot if applicable
if(all(gui.enabled.scatter))
    p1  = gui.data.proj.d1*gui.data.rast;
    p2  = gui.data.proj.d2*gui.data.rast;
    set(gui.scatter.data,'xdata',p1,'ydata',p2);
end

% % add the ID of the stimulus
% if(gui.enabled.movie(1))
%     gui.movie.stim.String = strrep(gui.data.stim,'_',' ');
% elseif(gui.enabled.traces(1))
%     gui.traces.stim.String = strrep(gui.data.stim,'_',' ');
% end