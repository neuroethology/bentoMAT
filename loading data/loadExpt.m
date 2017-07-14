function loadExpt(source,~,action)

if(strcmpi(class(source),'matlab.ui.Figure'))
    useSource = source;
else
    useSource = source.Parent.Parent;
end

[FileName,PathName] = uigetfile('*.xls;*.xlsx');
if(~FileName)
    return;
end

gui = guidata(useSource);

switch action
    case 'edit'
        exptBuilder = build_experiment(source,[]);
        unpackExptToBuilder(exptBuilder.f,[PathName FileName],exptBuilder);
    case 'load'
        transferExptToGui([PathName FileName],gui);
end