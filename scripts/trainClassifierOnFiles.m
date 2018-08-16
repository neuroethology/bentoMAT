function trainClassifierOnFiles(loader,behaviorMap)
    config  = loadConfig();
    [flag,path_to_MARS] = BentoPyConfig(config); %initialize python
    if(isunix)
        py.sys.setdlopenflags(int32(10));
    end
    if(flag)
        msgbox('Unable to set up MARS.');
        return;
    end

    % load the filelist from the sheet
    if(~exist('loader','var') || isempty(strfind(loader,'xls')))
        [loader, pth] = uigetfile({'*.xls';'*.xlsx'},'Pick a Bento spreadsheet');
        if(~loader)
            return;
        end
        loader = [pth loader];
    end
    [data,populated] = getAllFilesFromSheet(loader);

    % ask the user which annotations to train on + what mask to use
    if(~exist('behaviorMap','var'))
        [behaviorMap,mask] = promptTrainingBehaviors(data,populated);
    end
    behavior = fieldnames(behaviorMap);
    [behaviorMap,chList] = makePythonDict(behaviorMap);
    % todo: ask whether to hold out a percentage of trials for testing?

    suggestedName = {'new_mlp'};
    suggestedName = inputdlg('Prefix to use for classifier name?','Name your classifier',1,suggestedName);
    suggestedName = suggestedName{1};
    suggestedName(ismember(suggestedName,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
    if(isempty(suggestedName))
        suggestedName = 'new_mlp';
    end
    
    [~,feats,annot,front,frame_start,frame_stop] = makePythonStructs(data,populated,1,mask);
    disp(['Using data in ' loader]);
    disp(['to train classifier(s) for ' strjoin(behavior,',') '...']);
    py.mars_cmd_train.train_classifier(py.list(behavior),feats,annot,false,false,[],false,[],...                          
            pyargs('front_pose_files',front,'model_str',[path_to_MARS 'Bento'],...
                   'model_type','mlp','frame_start',frame_start,'frame_stop',frame_stop,...
                   'useChannel',chList,'behavior_dict',behaviorMap));
    disp('done! Your trained classifier(s) can be found under:');
    disp(['    ' path_to_MARS 'Bento/' suggestedName '*.dill']);
end

function [behaviorList,chList] = makePythonDict(behaviorList)
    labels = fieldnames(behaviorList);
    str = {};chList = {};
    for b = 1:length(labels)
        bhvs    = strsplit(strjoin(behaviorList.(labels{b}),':'),':');
        chList  = [chList bhvs(1:2:end)];
        bhvs    = bhvs(2:2:end);
        str = [str labels(b) {bhvs}];
    end
    behaviorList = py.dict(pyargs(str{:}));
    chList       = py.list(unique(chList));
end


% dict-creation gui and assistant functions:-------------------------------

function [behaviorList,mask] = promptTrainingBehaviors(data,populated)
    behaviorList=[];mask=[];
    allBhvs={}; %get a list of all behaviors used across the provided annotations
    for i = 1:size(populated,1)
        m    = populated(i,1);
        sess = ['session' num2str(populated(i,2))];
        tr   = populated(i,3);

        if(isempty(data(m).(sess)(tr).io.annot.fid{1}))
            continue;
        end
        annot = data(m).(sess)(tr).annot;
        for f = fieldnames(annot)'
            allBhvs = [allBhvs strcat([f{:} ':'],fieldnames(annot.(f{:})))'];
        end
    end
    allBhvs = unique(allBhvs);
    
    % now make a figure to assign behaviors to training labels~
    close(figure(9876));
    hfig = figure(9876);clf;
    style = {'units','normalized','fontsize',10};
    set(hfig,'dockcontrols','off','menubar','none',...
        'NumberTitle','off','Position', hfig.Position.*[.9 .85 1.15 0.8],...
        'units','normalized');
    
    h.h0    = hfig;
    h.Train = uipanel('parent',hfig,style{:},'position',[0 0 1 1]);
    % buttons
    h.resume = uicontrol('parent',h.Train,'style','pushbutton',style{:},...
        'position',[.8 .66 .175 .2],'string','OK','tag','train','callback',@submitList);
    h.rmClf = uicontrol('parent',h.Train,'style','pushbutton',style{:},...
        'position',[.8125 .475 .15 .1],'string','delete label','callback',{@rmFromList,'clf'},'enable','off');
    h.saveClf = uicontrol('parent',h.Train,'style','pushbutton',style{:},...
        'position',[.8125 .3625 .15 .1],'string','re-save label','callback',{@saveLbl,'clf'},'enable','off');
    uicontrol('parent',h.Train,'style','pushbutton',style{:},...
        'position',[.4 .55 .05 .15],'string','>>','tag','train','callback',{@addToList,'clf'});
    h.rmMask = uicontrol('parent',h.Train,'style','pushbutton',style{:},...
        'position',[.8125 .2125 .15 .1],'string','delete mask','callback',{@rmFromList,'mask'},'enable','off');
    h.saveMask = uicontrol('parent',h.Train,'style','pushbutton',style{:},...
        'position',[.8125 .1 .15 .1],'string','re-save mask','callback',{@saveLbl,'mask'},'enable','off');
    uicontrol('parent',h.Train,'style','pushbutton',style{:},...
        'position',[.4 .125 .05 .15],'string','>>','tag','train','callback',{@addToList,'mask'});

    % source
    uicontrol('parent',h.Train,style{:},'style','text','position',[0.025 .865 .35 .05],...
            'string','List of annotations found:');
    h.bhvrsTrain = uicontrol('parent',h.Train,style{:},'style','listbox','position',[0.025 .075 .35 .775],...
            'string',allBhvs,'Min',1,'Max',length(allBhvs)+1);
        
    % train list
    uicontrol('parent',h.Train,style{:},'style','text','position',[0.475 .865 .3 .05],...
            'string','Labels to train:');
    h.clf = uicontrol('parent',h.Train,style{:},'style','listbox','position',[0.475 .4 .3 .45],...
            'string',{},'Min',0,'Max',1,'callback',@clfListCallback);
    % mask list
    uicontrol('parent',h.Train,style{:},'style','text','position',[0.475 .235 .3 .05],...
            'string','Training mask:');
    h.mask = uicontrol('parent',h.Train,style{:},'style','popupmenu','position',[0.475 .075 .3 .15],...
            'string',{'(none)'});

    h.bhvStruct  = struct();
    h.maskStruct = [];
    guidata(h.h0,h);
    
    waitfor(h.resume);
    h = guidata(h.h0);
    behaviorList = h.bhvStruct;
    mask         = h.maskStruct;
    close(h.h0);
end


function clfListCallback(source,~)
    h       = guidata(source);
    if(isempty(source.String))
        return;
    end
    key     = source.String{source.Value};
    labels  = h.bhvStruct.(key);
    
    matches = [];
    for i=1:length(labels)
        matches(i) = find(strcmpi(h.bhvrsTrain.String,labels{i}));
    end
    h.bhvrsTrain.Value = matches;
end


function addToList(source,~,listID)
    h   = guidata(source);
    bhvs = h.bhvrsTrain.String(h.bhvrsTrain.Value);
    
    if(length(bhvs)==1 || strcmpi(listID,'mask'))
        str = strsplit(strjoin(bhvs,':'),':');
        str = strjoin(str(2:2:end),'+');
    else
        str = inputdlg('Name of label to be applied by classifier:');
        if(isempty(str)), return; end
        str = str{1};
        str(ismember(str,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
        str = strrep(str,' ','_');
    end
    
    if(strcmpi(listID,'clf'))
        h.(listID).String{end+1} = str;
        h.(listID).Value    = length(h.(listID).String);
        h.bhvStruct.(str)   = bhvs;
        h.rmClf.Enable      = 'on';
        h.saveClf.Enable    = 'on';
    else
        h.(listID).String   = {str};
        h.(listID).Value    = 1;
        str = strsplit(strjoin(bhvs,':'),':');
        h.maskStruct.Ch     = str(1:2:end);
        h.maskStruct.beh    = str(2:2:end);
        h.rmMask.Enable     = 'on';
        h.saveMask.Enable   = 'on';
    end
    guidata(h.h0,h);
end

function rmFromList(source,~,type)
    h = guidata(source);
    toRm = h.(type).String{h.(type).Value};
    h.bhvStruct = rmfield(h.bhvStruct,toRm);
    guidata(h.h0,h);
    
    h.(type).String(h.(type).Value) = [];
    h.(type).Value = 1;
    if(strcmpi(type,'clf') && isempty(h.clf.String))
        h.rmClf.Enable      = 'off';
        h.saveClf.Enable    = 'off';
    elseif(strcmpi(type,'mask'))
        h.(type).String     = {''};
        h.rmMask.Enable     = 'off';
        h.saveMask.Enable   = 'off';
    end
end

function saveLbl(source,~,type)
    h       = guidata(source);
    str     = h.(type).String{h.(type).Value};
    bhvs    = h.bhvrsTrain.String(h.bhvrsTrain.Value);
    
    h.bhvStruct.(str) = bhvs;
    guidata(h.h0,h);
end

function submitList(source,~)
    h       = guidata(source);
    delete(h.resume);
end



