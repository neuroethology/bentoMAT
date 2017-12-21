function redrawBuilder(source,~)
gui = guidata(source);

res             = get(source,'position');
colSizes        = [40*ones(1,2) 100 300];
colSizes        = [colSizes*(res(3)*0.63-23-90)/sum(colSizes) 30 30 30];

set(gui.t,'columnwidth',mat2cell(colSizes,1,ones(1,length(colSizes))));