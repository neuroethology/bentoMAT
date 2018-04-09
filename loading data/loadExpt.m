function loadExpt(source,~,action)

if(strcmpi(class(source),'matlab.ui.Figure'))
    useSource = source;
else
    useSource = source.Parent.Parent;
end

% remember where the last bento file you opened was?
[FileName,PathName] = uigetfile('*.xls;*.xlsx');
if(~FileName)
    return;
end

gui = guidata(useSource);

switch action
    case 'edit'
        exptBuilder = build_experiment(source,[]);
        unpackExptToBuilder(exptBuilder.f,[PathName FileName],exptBuilder,gui);
    case 'load'
        transferExptToGui([PathName FileName],gui);
end