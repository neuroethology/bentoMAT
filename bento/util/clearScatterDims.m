function clearScatterDims(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

gui.data.proj.d1 = [];
gui.data.proj.d2 = [];

gui.enabled.scatter(2) = 0;
gui.enabled.traces(2)  = 1;

gui = redrawPanels(gui);
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);