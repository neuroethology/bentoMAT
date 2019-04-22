function loadSavedAnnot(source,~)%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



data = guidata(source);
data.bhv = data.bhvS;
guidata(source,data);
updateSliderAnnot(data);
updatePlot(source,[]);