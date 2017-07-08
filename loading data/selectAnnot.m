function selectAnnot(source,~)

if(strcmpi(class(source),'matlab.ui.Figure')) useSource = source;
else useSource = source.Parent.Parent; end
gui = guidata(useSource);

[fname,pathname] = uigetfile([gui.config.root '*.txt']);

loadAnnot([pathname fname]);