function addRow(source,~)

gui = guidata(source);
dat = get(gui.t,'data');

dat(end+1,4)  = {''};
dat{end,1}    = dat{end-1,1};
dat{end,2}    = dat{end-1,2};
dat{end,3}    = dat{end-1,3}+1;
dat(end,5:16) = {[]};
txt           = [5 9 10 15 16];
dat(end,txt)  = {''};


set(gui.t,'data',dat);
pP   = get(gui.bP,'position');
pM   = get(gui.bM,'position');
res = get(get(source,'parent'),'position');
if(pP(2)>.23)
    set(gui.bP,'position',pP-[0 23 0 0]/res(4));
    set(gui.bM,'position',pM-[-.25 23 0 0]/res(4));
end
guidata(source,gui);
