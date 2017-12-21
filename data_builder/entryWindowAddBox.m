function entryWindowAddBox(source,eventdata)

h = guidata(source);
ss = h.ss;
fn = strrep(eventdata.Source.String{eventdata.Source.Value},' ','_');
if(isempty(fn)|fn(1)=='_'|fn(1)=='-')
    return;
end

rows = [];
h.fields(end+1).type    = fn;
h.fields(end).wrap      = uipanel(h.f,ss.subpanel{:},'units','pixels','position',[15 h.bump 750 ss.rowsize]);
h.fields(end).p         = uipanel(h.fields(end).wrap,ss.panel{:},'title',strrep(fn,'_',' '),'position',[25 1 700 ss.rowsize]);
h.fields(end).rm        = uicontrol(h.fields(end).wrap,'style','pushbutton',ss.C{:},'position',[1 1 20 20],...
                                    'string','X','callback',{@entryWindowRmBox,length(h.fields)});
eval(['[h.fields(end).data,rows] = ' fn '(h.fields(end).p,ss);']);

h.bump = h.bump - ss.rowsize*length(rows) - 20;
bump = h.bump;
if(h.bump<=10)
    h.bump = 10;
end
h.fields(end).wrap.Position = [15 h.bump 750 ss.rowsize*length(rows) + 20];
h.fields(end).rm.Position   = [1 (ss.rowsize*length(rows))/2 20 20];
h.fields(end).p.Position    = [30 1 690 ss.rowsize*length(rows) + 20];
h.fields(end).rows          = rows;

guidata(h.f,h);
h.f.Position(4) = h.f.Position(4) - bump + 10;
h.f.Position(2) = h.f.Position(2) + bump - 10;
resizeEntryWindow(h.f,[]);