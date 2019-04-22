function loadTable(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

pth = get(gui.root,'string');
if(~strcmpi(pth(end),'\'))
    pth = [pth '\'];
end
[FileName,PathName] = uigetfile([pth '*.xls;*.xlsx']);
if(~FileName)
    return;
end

unpackExptToBuilder(source,[PathName FileName],gui);