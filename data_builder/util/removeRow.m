function removeRow(source,~)

gui = guidata(source);
dat = get(gui.t,'data');
if(size(dat,1)<=1)
    return;
end
dat(end,:) = [];