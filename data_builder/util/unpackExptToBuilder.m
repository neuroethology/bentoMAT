function unpackExptToBuilder(source,pth,gui)
if(strcmpi(class(source),'matlab.ui.Figure'))
    useSource = source;
else
    useSource = source.Parent;
end

[~,~,raw] = xlsread(pth,'Sheet1');
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'/',filesep);
raw(cellfun(@isstr,raw)) = strrep(raw(cellfun(@isstr,raw)),'\',filesep);
for i = 3:size(raw,1)
    inds = [4 5 9];
    mask = cellfun(@sum,cellfun(@isnan,raw(i,inds),'uniformoutput',false));
    raw(i,inds(find(mask))) = {''};
    inds = [6 7 8 10 11 12];
    mask = cellfun(@sum,cellfun(@isnan,raw(i,inds),'uniformoutput',false));
    raw(i,inds(find(mask))) = {[]};
end

set(gui.root,'String',raw{1,1});

fieldset = raw(2,:);
fields = struct();
for i=1:length(fieldset)
    str = strrep(fieldset{i},' ','_');
    str = strrep(str,'_#','');
    fields.(str) = i;
end
[M,matchInds] = reconcileSheetFormats(gui,raw,fieldnames(fields));
gui.t.Data = M;

if(~isnumeric(raw{1,3})) %variable Ca framerate
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
if(~isnumeric(raw{1,5})) %variable annot framerate
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
set(gui.CaMulti,   'Value', raw{1,7});
set(gui.annoMulti, 'Value', raw{1,9});
set(gui.incMovies, 'Value', raw{1,11});
gui.rowVis(matchInds.Start_Ca)         = raw{1,7};
gui.rowVis(matchInds.Stop_Ca)          = raw{1,7};
gui.rowVis(matchInds.Start_Anno)       = raw{1,9};
gui.rowVis(matchInds.Stop_Anno)        = raw{1,9};
gui.rowVis(matchInds.Behavior_movie)   = raw{1,11};
gui.rowVis(matchInds.Offset)           = raw{1,13};
gui.rowVis(matchInds.Tracking)         = raw{1,15};
gui.rowVis(matchInds.Audio_file)       = raw{1,17};
gui.rowVis(isnan(gui.rowVis)) = 0;

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
