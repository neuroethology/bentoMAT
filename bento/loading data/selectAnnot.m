function selectAnnot(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(strcmpi(class(source),'matlab.ui.Figure')) useSource = source;
else useSource = source.Parent.Parent; end
gui = guidata(useSource);

[fname,pathname] = uigetfile([gui.config.root '*.txt']);

loadAnnot([pathname fname]);