function removeRow(source,~)

gui = guidata(source);
dat = get(gui.t,'data');
if(size(dat,1)<=1)
    return;
end
dat(end,:) = [];

set(gui.t,'data',dat);
pP   = get(gui.bP,'position');
pM   = get(gui.bM,'position');
res = get(get(source,'parent'),'position');
set(gui.bP,'position',pP+[0 23 0 0]/res(4));
set(gui.bM,'position',pM+[0 23 0 0]/res(4));
guidata(source,gui);