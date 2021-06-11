function setChannel(source,~)
%changes which channel is being displayed/annotated on
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui     = guidata(source);
gui     = readoutAnnot(gui);
gui.annot.activeCh = source.String{source.Value};
gui     = transferAnnot(gui,gui.data);

if(strcmpi(gui.annot.activeCh,'thresholded_features'))
    gui = redrawFeaturePlots(gui);
end

updateSliderAnnot(gui);
updateLegend(gui,1);
guidata(source,gui);
updatePlot(gui.h0,[]);