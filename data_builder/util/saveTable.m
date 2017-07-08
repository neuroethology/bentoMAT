function saveTable(source,~)
gui = guidata(source);

M = packExperiment(gui);

% and save!
[FileName,PathName] = uiputfile([M{1,1} '*.xls;*.xlsx']);
if(FileName)
    if(~isempty(dir([PathName FileName])))
        delete([PathName FileName]); %clear out old data (the lazy way!)
    end
    xlswrite([PathName FileName],M,'Sheet1');
end