function redrawBuilder(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

res             = get(source,'position');
txt             = [5 9 10 15 16 17 18];
cw              = (res(3)*0.98 - 50*sum(gui.rowVis(setdiff(1:18,txt))) - 26) / sum(gui.rowVis(txt));
colSizes        = 50*ones(1,18);
colSizes(txt)   = cw;
colSizes        = colSizes.*gui.rowVis;

set(gui.t,'columnwidth',mat2cell(colSizes,1,ones(1,length(colSizes))));