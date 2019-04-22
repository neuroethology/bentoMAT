function scrollLegend(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui=guidata(source);

gui.legend.axes.Position(2) = 1-source.Value;