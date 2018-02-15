function unpackExptToBuilder(source,pth,gui,parent)
if(strcmpi(class(source),'matlab.ui.Figure'))
    useSource = source;
else
    useSource = source.Parent;
end

[~,~,raw] = xlsread(pth,'Sheet1');
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'/',filesep);
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'\',filesep);
raw(cell2mat(cellfun(@(x) all(isnan(x)),raw,'uniformoutput',false))) = {''};

set(gui.root,'String',raw{1,1}); %parent directory
parent.pth = raw{1,1}; guidata(parent.h0,parent); %save parent directory in main bento gui also

fieldset = raw(2,:); % list of data fields in the excel sheet
fields = struct();
for i=1:length(fieldset)
    str = strrep(fieldset{i},' ','_');
    str = strrep(str,'_#','');
    fields.(str) = i;
end
[M,matchInds] = reconcileSheetFormats(gui,raw,fieldnames(fields));
gui.t.Data = M;
raw{1,20}='';

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

res  = get(useSource,'position');
pP   = [.025 .792 .02 .02*res(3)/res(4)];
pM   = [.05 .792 .02 .02*res(3)/res(4)];
for i = 1:size(get(gui.t,'data'),1)
    if(pP(2)>.18)
        pP = pP - [0 23 0 0]/res(4);
        pM = pM - [0 23 0 0]/res(4);
        set(gui.bP,'position',pP);
        set(gui.bM,'position',pM);
    end
end

p = get(gui.f,'position');
set(gui.bP,'Position',[.025 .792-23*size(get(gui.t,'data'),1)/p(4) .02 .02*p(3)/p(4)]);
set(gui.bM,'Position',[.05 .792-23*size(get(gui.t,'data'),1)/p(4) .02 .02*p(3)/p(4)]);

guidata(useSource,gui);
redrawBuilder(useSource,[]);
