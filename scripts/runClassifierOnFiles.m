function runClassifierOnFiles(loader,clfName)

config  = loadConfig();
[flag,path_to_MARS] = BentoPyConfig(config); %initialize python
if(flag)
    msgbox('Unable to set up MARS.');
    return;
end

if(~exist('loader','var') || isempty(strfind(loader,'xls')))
    [loader, pth] = uigetfile({'*.xls';'*.xlsx'},'Pick a Bento loader');
    if(~loader)
        return;
    end
    loader = [pth loader];
end
[data,populated] = getAllFilesFromSheet(loader);

if(~exist('clfName','var'))
    [clfName,clfPath] = uigetfile([path_to_MARS 'Bento\*.dill'],'multiSelect','on');
    if(~clfName)
        return;
    end
    clfName = strcat(clfPath,clfName);
end

[movies,feats] = makePythonStructs(data,populated,0,[]);
disp('running classifier(s)...');
py.mars_cmd_test.run_classifier(py.list({clfName}),feats,movies);
disp('done!');

disp('creating new bento file with classifier outputs...');
[~,~,raw] = xlsread(loader,'Sheet1');
[~,matches,~] = reconcileSheetFormats([],raw);
for i=1:size(populated,1)
    ind = strfind(raw{2+i,matches.Tracking})-1;
    if(isempty(raw{2+i,matches.Annotation_file}))
        raw{2+i,matches.Annotation_file} = [raw{2+i,matches.Tracking}(1:ind) 'actions_pred.annot'];
    else
        raw{2+i,matches.Annotation_file} = [raw{2+i,matches.Annotation_file} ';' ...
                                            raw{2+i,matches.Tracking}(1:ind) 'actions_pred.annot'];
    end
end
xlswrite(strrep(loader,'.xls','_predictions.xls'),raw,'Sheet1');
disp('done!');









