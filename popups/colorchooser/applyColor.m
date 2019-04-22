function applyColor(source,~,parent)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


data = guidata(source);
gui  = guidata(parent);

for i = 1:length(data.h.bhvrs)
    beh = strrep(data.h.lbls(i).String,' ','_');
    newColor = data.h.bhvrs(i).BackgroundColor;
    gui.annot.cmap.(beh) = newColor;
    gui.annot.cmapDef.(beh) = newColor;
end

guidata(gui.h0,gui);

updateSliderAnnot(gui);
updatePlot(gui.h0,[]);
updateLegend(gui);
updatePreferredCmap(gui.annot.cmapDef,gui.annot.hotkeysDef);

close(data.h0);