function saveAnnotFile(source,~,pth)
gui = guidata(source);

bhvpic = gui.data.bhv;
labels = gui.data.lbls;
cmap   = gui.data.cmap;
rast   = gui.data.rast(:,2:end-1);

fname = uiputfile([pth '*.mat']);

save([pth fname],'bhvpic','labels','cmap','rast');