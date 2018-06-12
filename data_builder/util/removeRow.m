function removeRow(source,~)

gui = guidata(source);
dat = get(gui.t,'data');
if(size(dat,1)<=1)
    return;
end
inds = gui.t.UserData(:,1);
dat(inds,:) = [];

set(gui.t,'data',dat);
guidata(source,gui);