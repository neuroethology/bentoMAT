function redrawBuilder(source,~)
gui = guidata(source);

res      = get(source,'position');
if(gui.rowVis(14)==1)
    cw       = (res(3)*.98 - 50*(sum(gui.rowVis)-3) - 26)/3;
else
    cw       = (res(3)*.98 - 50*(sum(gui.rowVis)-2) - 26)/2;
end
colSizes = [50 50 50 50 cw 50 50 50 cw 50 50 50 50 cw].*gui.rowVis;

set(gui.t,'columnwidth',mat2cell(colSizes,1,ones(1,length(colSizes))));