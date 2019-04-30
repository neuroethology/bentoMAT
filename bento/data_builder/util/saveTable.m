function saveTable(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

M = packExperiment(gui);

% and save!
[FileName,PathName] = uiputfile([M{1,1} '*.xls;*.xlsx']);
if(FileName)
    if(~isempty(dir([PathName FileName])))
        delete([PathName FileName]); %clear out old data (the lazy way!)
    end
    if(isunix)
        try
            javaaddpath([fileparts(mfilename('fullpath')) '/poi_library/dom4j-1.6.1.jar']);
            javaaddpath([fileparts(mfilename('fullpath')) '/poi_library/xmlbeans-2.3.0.jar']);
            javaaddpath([fileparts(mfilename('fullpath')) '/poi_library/poi-3.8-20120326.jar']);
            javaaddpath([fileparts(mfilename('fullpath')) '/poi_library/poi-ooxml-3.8-20120326.jar']);
            javaaddpath([fileparts(mfilename('fullpath')) '/poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
            javaaddpath([fileparts(mfilename('fullpath')) '/poi_library/stax-api-1.0.1.jar']);
            xlwrite([PathName FileName],M); % for linux computers
        catch
            disp('Save failed. Make sure you have Apache POI 3.8 or 3.9 on your Matlab Java path:');
            disp('javaaddpath(''poi-library/ooxml-lib/dom4j-1.6.1.jar'');');
            disp('javaaddpath(''poi-library/ooxml-lib/xmlbeans-2.3.0.jar'');');
            disp('javaaddpath(''poi-library/poi-3.9-20121203.jar'');');
            disp('javaaddpath(''poi-library/poi-ooxml-3.9-20121203.jar'');');
            disp('javaaddpath(''poi-library/poi-ooxml-schemas-3.9-20121203.jar'');');
            disp('(replace ''poi-library'' with the full path to your poi library.)');
        end
    else
        xlswrite([PathName FileName],M);
    end
end