function changeyScale(source,~,sc)%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

gui.traces.yScale = gui.traces.yScale * sc;
guidata(source,gui);

updatePlot(source,[]);