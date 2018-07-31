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

[movie,feat,front] = makePythonStructs(data,populated,0,[]);

for g = unique(groups)
    behavior    = py.list(strrep(bhvrs(groups==g),'_','-')');
    model_type  = strrep(modelTypes{g},'*','');
    if(strfind(modelTypes{g},'*'))
        model_dir = 'Bento_temp';
    else
        model_dir = 'Bento';
    end
    py.mars_cmd_test.test_classifier(behavior,feat,movie,...
        pyargs('front_pose_files',front,'model_str',[path_to_MARS model_dir],...
        'output_suffix',model_type,'save_probabilities', 1) );
end











