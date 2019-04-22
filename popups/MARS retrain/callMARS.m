function callMARS(source,~,gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



[flag,path_to_MARS,config] = BentoPyConfig(gui.config); %initialize python
if(flag)
    msgbox('Unable to set up MARS.');
    return;
end
gui.config = config; guidata(gui.h0,gui);

h           = guidata(source);
doTrain     = strcmpi(source.Tag,'train');
doTest      = strcmpi(source.Tag,'test') | h.evalTrain.Value;
doSubs      = h.doSubs.Value;
doPrecRec   = 0;

if(doTrain)
    set(h.doTrain,'String',['<html><div align=center><img src="file:' fileparts(mfilename('fullpath')) ...
                    filesep 'spinner.gif" width=40 height=40><br>Training classifier...</div></html>']);
    drawnow;
    
    bhvr        = h.bhvrsTrain.String{h.bhvrsTrain.Value};
    behavior    = py.list({bhvr});
    
    model_dir   = 'Bento_temp';
    model_type  = 'mlp';
    trials = h.trialsTrain.String(h.trialsTrain.Value);
    for i=1:length(trials)
        vals(i,:)    = sscanf(trials{i},'mouse %d, session %d, trial %d');
    end
    
    if(doSubs)
        mask.Ch = h.maskChannel.String{h.maskChannel.Value};
        mask.beh = h.maskLabel.String{h.maskLabel.Value};
    else
        mask = [];
    end
    
    % this part actually does the training!--------------------------------
    tic
    [movies,feat,annot,front,frame_start,frame_stop] = makePythonStructs(gui.allData,vals,1,mask);
    try
        py.mars_cmd_train.train_classifier(behavior,feat,annot,movies,false,[],false,[],...
            pyargs('front_pose_files',front,'model_str',[path_to_MARS model_dir],...
                   'model_type',model_type,'frame_start',frame_start,'frame_stop',frame_stop,...
                   'useChannel',py.list(h.chsTrain.String(h.chsTrain.Value))));
    catch
        keyboard
        set(h.doTrain,'String','Train MARS');
        msgbox('Training failed to converge- more examples needed.');
        return;
    end
    toc
    % ---------------------------------------------------------------------
    
    
    set(h.doTrain,'String','Train MARS');
    bhvr = strrep(bhvr,'_','-');
    if(any(strcmpi(h.bhvrsTest.String,[bhvr '_' model_type '*'])))
        h.bhvrsTest.String = [{[bhvr '_' model_type '*']}; setdiff(h.bhvrsTest.String,[bhvr '_' model_type '*'])];
    elseif(isempty(h.bhvrsTest.String))
        h.bhvrsTest.String = {[bhvr '_' model_type '*']};
        h.bhvrsTest.Max = 1;
    else
        newBhvStrs = [{[bhvr '_' model_type '*']};h.bhvrsTest.String];
        newBhvStrs(cellfun(@isempty,newBhvStrs)) = [];
        set(h.bhvrsTest,'String',newBhvStrs);
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
        bhvrs{1}        = strrep(bhvr,'-','_');
    else
        models      = h.bhvrsTest.String(h.bhvrsTest.Value);
        bhvrs       = cellfun(@(x) x(1:(find(x=='_',1,'first')-1)),models,'uniformoutput',false);
        [modelTypes,~,groups] = unique(cellfun(@(x) x((find(x=='_',1,'first')+1):end),models,'uniformoutput',false));
        trials = h.trialsTest.String(h.trialsTest.Value);
        doPrecRec = ~strcmpi(h.GT.String{h.GT.Value},'--none--');
        GT = h.GT.String{h.GT.Value};
    end
        
    f = waitbar(0,'Classifying movies...');
    for i=1:length(trials)
        waitbar((i-1)/length(trials),f,...
                ['Classifying movie ' num2str(i) '/' num2str(length(trials)) '...']);

        vals = sscanf(trials{i},'mouse %d, session %d, trial %d')';
        [movie,feat,front] = makePythonStructs(gui.allData,vals,0,[]);

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

        % import the new annotations back into Bento~:
        gui = updateWithMARSOutputs(gui,vals,model_type);
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
    
    if(doPrecRec)
        MARSPrecRecReport(bhvrs,gui,trials,GT);
    end
end



