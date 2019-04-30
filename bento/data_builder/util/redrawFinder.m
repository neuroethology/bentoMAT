function redrawFinder(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui = guidata(source);
res   = get(source,'position');
set(gui.tCa,'columnwidth',{res(3)*.98-23});