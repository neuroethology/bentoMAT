function callMARS(source,~,gui)

[flag,path_to_MARS] = BentoPyConfig(gui); %initialize python
if(flag)
    msgbox('Unable to set up MARS.');
    return;
end

h           = guidata(source);
doTrain     = strcmpi(source.Tag,'train');
doTest      = strcmpi(source.Tag,'test') | h.evalTrain.Value;

if(doTrain)
    set(h.h1Train,'String',['<html><div align=center><img src="file:' fileparts(mfilename('fullpath')) ...
                    '\spinner.gif" width=40 height=40><br>Training classifier...</div></html>']);
    drawnow;
    
    bhvr        = h.bhvrsTrain.String{h.bhvrsTrain.Value};
    behavior    = py.list({bhvr});
    
    model_dir   = 'Bento_temp';
    model_type  = 'xgb500';
    trials = h.trialsTrain.String(h.trialsTrain.Value);
    for i=1:length(trials)
        vals(i,:)    = sscanf(trials{i},'mouse %d, session %d, trial %d');
    end
    tic
    [movies,feat,annot,front] = makePythonStructs(gui,vals,1);
    py.mars_cmd_train.train_classifier(behavior,feat,annot,movies,false,[],false,[],...                          
        pyargs('front_pose_files',front,'model_str',[path_to_MARS model_dir],'model_type',model_type) );
    toc
    
    set(h.h1Train,'String','Train MARS');
    if(any(strcmpi(h.bhvrsTest.String,[bhvr '_' model_type '*'])))
        h.bhvrsTest.String = [{[bhvr '-' model_type '*']}; setdiff(h.bhvrsTest.String,[bhvr '-' model_type '*'])];
    elseif(isempty(h.bhvrsTest.String))
        h.bhvrsTest.String = {[bhvr '-' model_type '*']};
        h.bhvrsTest.Max = 1;
    else
        set(h.bhvrsTest,'String',[{[bhvr '-' model_type '*']};h.bhvrsTest.String]);
        h.bhvrsTest.Max = h.bhvrsTest.Max+1;
    end
    drawnow;
end


if(doTest)
    % need to get a value for model_type unless we're testing a just-trained model
    if(doTrain)
        trials = h.trialsTrain.String(h.trialsTrain.Value);
        groups          = 1;
        modelTypes{1}   = [model_type '*'];
        bhvrs{1}        = bhvr;
    else
        models      = h.bhvrsTest.String(h.bhvrsTest.Value);
        bhvrs       = cellfun(@(x) x(1:(find(x=='_',1,'first')-1)),models,'uniformoutput',false);
        [modelTypes,~,groups] = unique(cellfun(@(x) x((find(x=='_',1,'first')+1):end),models,'uniformoutput',false));
        trials = h.trialsTest.String(h.trialsTest.Value);
    end
        
    f = waitbar(0,'Classifying movies...');
    for i=1:length(trials)
        waitbar((i-1)/length(trials),f,...
                ['Classifying movie ' num2str(i) '/' num2str(length(trials)) '...']);

        vals = sscanf(trials{i},'mouse %d, session %d, trial %d')';
        [movie,feat,front] = makePythonStructs(gui,vals,0);

        for g = unique(groups)
            behavior    = py.list(strrep(bhvrs(groups==g),'_','-')');
            model_type  = strrep(modelTypes{g},'*','');
            if(strfind(modelTypes{g},'*'))
                model_dir = 'Bento_temp';
            else
                model_dir = 'Bento';
            end
            py.mars_cmd_test.test_classifier(behavior,feat,movie,...
                pyargs('front_pose_files',front,'model_str',[path_to_MARS model_dir],'output_suffix',model_type) );
        end

        % import the new annotations back into Bento~:
        data    = gui.allData(vals(1)).(['session' num2str(vals(2))])(vals(3));
        pth     = fileparts(data.io.feat.fid{1});
        [~,mID] = fileparts(pth);
        fid     = [pth '\' mID '_actions_pred_' model_type '.txt'];
        data.annot.MARS_output       = getOnlineMARSOutput(fid);
        data.io.annot.fid{end+1}     = fid;
        data.io.annot.fidSave{end+1} = strrep(fid,'.txt','.annot');
        gui.allData(vals(1)).(['session' num2str(vals(2))])(vals(3)) = data;
    end
    waitbar(1,f,'Done!');

    gui.annot.activeCh = 'MARS_output';
    guidata(gui.h0,gui);
    gui = setActiveMouse(gui,gui.data.info.mouse,...
                             gui.data.info.session,...
                             gui.data.info.trial,false);
    guidata(gui.h0,gui);
    updatePlot(gui.h0,[]);
    close(f);
    figure(gui.h0);
end



