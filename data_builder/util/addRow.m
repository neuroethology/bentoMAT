function addRow(source,~)

gui = guidata(source);
dat = get(gui.t,'data');

dat(end+1,4:5)  = {'',''};
dat{end,1}    = dat{end-1,1};
dat{end,2}    = dat{end-1,2};
dat{end,3}    = dat{end-1,3}+1;
dat           = appendTableIcons(dat);


set(gui.t,'data',dat);