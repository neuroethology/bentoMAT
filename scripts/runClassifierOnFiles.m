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
    [clfName,clfPath] = uigetfile([path_to_MARS 'Bento\*.dill']);
    if(~clfName)
        return;
    end
    clfName = [clfPath clfName];
end

[movie,feat] = makePythonStructs(data,populated,0,[]);
disp('running classifier(s)...');
py.mars_cmd_test.run_classifier(py.list({clfName}),feat,movie);
disp('done!');











