function runClassifierOnFiles(loader,clfName)

config  = loadConfig();
[flag,path_to_MARS] = BentoPyConfig(config); %initialize python

if(isunix)
    py.sys.setdlopenflags(int32(10)); %would allow us to use h5py on linux computers (but right now we just avoid using it since there's no equivalent fix for windows)
end

if(flag)
    msgbox('Unable to set up MARS.');
    return;
end

if(~exist('loader','var') || isempty(strfind(loader,'xls')))
    [loader, pth] = uigetfile({'*.xls';'*.xlsx'},'Pick a Bento spreadsheet');
    if(~loader)
        return;
    end
    loader = [pth loader];
end
[data,populated] = getAllFilesFromSheet(loader);

if(~exist('clfName','var'))
    [clfName,clfPath] = uigetfile([path_to_MARS 'Bento' filesep '*.dill'],'Pick one or more classifiers','multiSelect','on');
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
[~,~,raw] = xlsread(loader);
[~,matches,~] = reconcileSheetFormats([],raw);
for i=1:size(populated,1)
    ind = strfind(raw{2+i,matches.Tracking},'raw_feat')-1;
    if(~isempty(ind))
        tstr = raw{2+i,matches.Tracking}(1:ind);
    else
        ind = strfind(raw{2+i,matches.Audio_file},'spectrogram')-1;
        tstr = raw{2+i,matches.Audio_file}(1:ind);
    end
    if(isempty(raw{2+i,matches.Annotation_file}))
        raw{2+i,matches.Annotation_file} = [tstr 'actions_pred.annot'];
    else
        raw{2+i,matches.Annotation_file} = [tstr ';' ...
                                            tstr 'actions_pred.annot'];
    end
end
xlswrite(strrep(loader,'.xls','_predictions.xls'),raw,'Sheet1');
disp('done!');









