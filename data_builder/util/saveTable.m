function saveTable(source,~)
gui = guidata(source);

M = packExperiment(gui);

% and save!
[FileName,PathName] = uiputfile([M{1,1} '*.xls;*.xlsx']);
if(FileName)
    if(~isempty(dir([PathName FileName])))
        delete([PathName FileName]); %clear out old data (the lazy way!)
    end
    if(exist('xlwrite',2))
        try
        xlwrite([PathName FileName],M); % for linux computers
        catch
            disp('Save failed. Make sure you have Apache POI 3.8 or 3.9 on your Matlab Java path:');
            disp('javaaddpath(''poi-3.9/ooxml-lib/dom4j-1.6.1.jar'');');
            disp('javaaddpath(''poi-3.9/ooxml-lib/xmlbeans-2.3.0.jar'');');
            disp('javaaddpath(''poi-3.9/poi-3.9-20121203.jar'');');
            disp('javaaddpath(''poi-3.9/poi-ooxml-3.9-20121203.jar'');');
            disp('javaaddpath(''poi-3.9/poi-ooxml-schemas-3.9-20121203.jar'');');
            disp('(replace ''poi-3.9'' with the full path to your poi library.)');
        end
    else
        xlswrite([PathName FileName],M,'Sheet1');
    end
end