function saveAnnotFile(source,~,pth)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

bhvpic = gui.data.bhv;
labels = gui.data.lbls;
cmap   = gui.data.cmap;
rast   = gui.data.rast(:,2:end-1);

fname = uiputfile([pth '*.mat']);

save([pth fname],'bhvpic','labels','cmap','rast');