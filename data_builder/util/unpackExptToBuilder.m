function unpackExptToBuilder(source,pth,gui,parent)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt
if(strcmpi(class(source),'matlab.ui.Figure'))
    useSource = source;
else
    useSource = source.Parent;
end

[~,~,raw] = xlsread(pth,'Sheet1'); %load the excel sheet

% fix nans/filename formatting issues
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'/',filesep);
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'\',filesep);
raw(cell2mat(cellfun(@(x) all(isnan(x)),raw,'uniformoutput',false))) = {''};

set(gui.root,'String',raw{1,1}); %get the parent directory
parent.pth = raw{1,1}; guidata(parent.h0,parent); %save parent directory in main bento gui also

[M,matchInds,fields] = reconcileSheetFormats(gui,raw); %populate the table
gui.t.Data = M;

raw{1,20}=''; %pad raw in case we're loading from an old sheet that doesn't have as many columns

% set the values of various checkboxes/toggles
if(any(~cellfun(@isempty,M(:,matchInds.FR_Ca))))
    set(gui.CaFRtog,'Value',1);
    set(gui.CaFR,'Enable','off');
    set(gui.CaFRtxt,'Enable','off');
    gui.rowVis(matchInds.FR_Ca) = 1;
else
    set(gui.CaFRtog,'Value',0);
    set(gui.CaFR,'Enable','on','String',raw{1,3});
    set(gui.CaFRtxt,'Enable','on');
    gui.rowVis(matchInds.FR_Ca) = 0;
end
if(any(~cellfun(@isempty,M(:,matchInds.FR_Anno))))
    set(gui.annoFRtog,'Value',1);
    set(gui.annoFR,'Enable','off');
    set(gui.annoFRtxt,'Enable','off');
    gui.rowVis(matchInds.FR_Anno) = 1;
else
    set(gui.annoFRtog,'Value',0);
    set(gui.annoFR,'Enable','on','String',raw{1,5});
    set(gui.annoFRtxt,'Enable','on');
    gui.rowVis(matchInds.FR_Anno) = 0;
end
set(gui.CaMulti,   'Value',   any(~cellfun(@isempty,raw(3:end,matchInds.Start_Ca))));
set(gui.annoMulti, 'Value',   any(~cellfun(@isempty,raw(3:end,matchInds.Start_Anno))));
set(gui.incMovies, 'Value',   any(~cellfun(@isempty,raw(3:end,matchInds.Behavior_movie))));
set(gui.offset,    'Value',   any(~cellfun(@isempty,raw(3:end,matchInds.Offset))));
set(gui.incTracking,'Value',  any(~cellfun(@isempty,raw(3:end,matchInds.Tracking))));
set(gui.incAudio,  'Value',   any(~cellfun(@isempty,raw(3:end,matchInds.Audio_file))));
set(gui.inctSNE,  'Value',    any(~cellfun(@isempty,raw(3:end,matchInds.tSNE))));

if(size(raw,1)>=3)
    for str = intersect(fieldnames(matchInds),fieldnames(fields))'
        gui.rowVis(matchInds.(str{:})) = any(~cellfun(@isempty,raw(3:end,fields.(str{:}))));
    end
    for str = setdiff(fieldnames(matchInds),fieldnames(fields))'
        gui.rowVis(matchInds.(str{:}))  = 0;
    end
end
gui.rowVis(isnan(gui.rowVis)) = 0;
gui.incAudio.Value = gui.rowVis(matchInds.Audio_file);

guidata(useSource,gui);
redrawBuilder(useSource,[]);
