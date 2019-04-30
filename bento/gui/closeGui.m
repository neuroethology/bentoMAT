function closeGui(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


data = guidata(source);

data.quitbutton = 1;
guidata(source,data);
set(source,'CloseRequestFcn','closereq');
