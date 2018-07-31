function MARSoptions(source,~)
    gui     = guidata(source);
    
    [flag,path_to_MARS] = BentoPyConfig(gui); %initialize python
    if(flag)
        msgbox('Unable to configure MARS successfully.');
        return;
    end

    stims   = {};
    for i=1:size(gui.allPopulated,1)
        m       = gui.allPopulated(i,1);
        sess    = ['session' num2str(gui.allPopulated(i,2))];
        tr      = gui.allPopulated(i,3);
        if(isempty(gui.allData(m).(sess)(tr).stim))
            stims{i} = '';
        else
            stims{i} = ['  (' gui.allData(m).(sess)(tr).stim ')'];
        end
    end
    trialList = strcat({'mouse '}, num2str(gui.allPopulated(:,1)),...
                       { ', session '}, num2str(gui.allPopulated(:,2)),...
                       { ', trial '}, num2str(gui.allPopulated(:,3)));
    trialList = strcat(trialList,stims');
    
    classifier_list         = ls([path_to_MARS 'Bento_temp/']);
    classifier_list(1:2,:)  = [];
    classifier_list = strrep(cellstr(classifier_list),'.dill','*');
    temp        = ls([path_to_MARS 'Bento/']);
    temp(1:2,:) = [];
    classifier_list = [classifier_list; strrep(cellstr(temp),'.dill','')];

    close(figure(9876));
    hfig = figure(9876);clf;
    style = {'units','normalized','fontsize',10};

    set(hfig,'dockcontrols','off','menubar','none',...
        'NumberTitle','off','Position', hfig.Position.*[.75 .75 1.45 1.25],...
        'units','normalized','Tag','trainMARS');
    
% Training panel-----------------------------------------------------------
    h.Train = uipanel('parent',hfig,style{:},'position',[0 .5 1 .5]);

    % right column
    h.doTrain = uicontrol('parent',h.Train,'style','pushbutton',style{:},...
        'position',[.725 .575 .225 .3],'backgroundcolor',[.65 1 .65],...
        'string','Train MARS','tag','train','callback',{@callMARS,gui});

    h.evalTrain = uicontrol('parent',h.Train,'style','checkbox',style{:},...
        'position',[.75 .4 .225 .15],'string','Run on training set','value',1);
    h.doSubs = uicontrol('parent',h.Train,'style','checkbox',style{:},'string','Use subset of frames',...
              'position',[.75 .25 .225 .15],'callback',@toggleSubsetWindow);
    h.doInit = uicontrol('parent',h.Train,'style','checkbox',style{:},'string','Warm start',...
              'position',[.75 0.1 .225 .15],'callback',@toggleClfWindow,'visible','off'); %rm visible-off tag once implemented

    % center column
    h.h2Train = uipanel('parent',h.Train,style{:},'position',[.3 .055 .4 .95],'bordertype','none');
    uicontrol('parent',h.h2Train,style{:},'style','text','position',[0 .725 .95 .2],...
            'string','Train from trials:','horizontalalign','left');
    h.trialsTrain = uicontrol('parent',h.h2Train,style{:},'style','listbox','position',[0 0 .95 .85],...
            'string',trialList,'min',1,'max',length(trialList));

    % left column
    h.h3Train = uipanel('parent',h.Train,style{:},'position',[0.0125 .65 .25 .3],'bordertype','none','visible','on');
    uicontrol('parent',h.h3Train,style{:},'style','text','position',[0 .7 1 .3],...
            'string','Train behavior:','horizontalalign','left');
    h.chsTrain = uicontrol('parent',h.h3Train,style{:},'style','popupmenu','position',[0.05 .3625 .95 .3],...
            'string',gui.annot.channels);
    h.bhvrsTrain = uicontrol('parent',h.h3Train,style{:},'style','popupmenu','position',[0.05 .025 .95 .3],...
            'string',fieldnames(gui.annot.bhv));

    % optional: specify subset of frames to train from:
    h.h4Train = uipanel('parent',h.Train,style{:},'position',[0.0125 .3125 .25 .3],...
            'bordertype','none','foregroundcolor',[.5 .5 .5],'visible','off');
    uicontrol('parent',h.h4Train,style{:},'style','text','position',[0 .7 1 .3],...
            'string','Only use frames from:','horizontalalign','left');
    h.maskChannel = uicontrol('parent',h.h4Train,style{:},'style','popupmenu','position',[0.05 .3625 .95 .3],...
            'string',gui.annot.channels,'callback',{@updateMaskBehaviorOptions,gui});
    h.maskLabel = uicontrol('parent',h.h4Train,style{:},'style','popupmenu','position',[0.05 .025 .95 .3],...
            'string',fieldnames(gui.annot.bhv),'min',1,'max',1);
        
    % optional: provide a classifier for a warm start:
    h.h5Train = uipanel('parent',h.Train,style{:},'position',[0.0125 0 .25 .275],...
            'bordertype','none','foregroundcolor',[.5 .5 .5],'visible','off');
    uicontrol('parent',h.h5Train,style{:},'style','text','position',[0 .7 1 .3],...
            'string','Initialize from classifier:','horizontalalign','left');
    h.maskChannel = uicontrol('parent',h.h5Train,style{:},'style','popupmenu','position',[0.05 .3625 .95 .3],...
            'string',classifier_list);
        
        
% Testing panel------------------------------------------------------------
    h.Test = uipanel('parent',hfig,style{:},'position',[0 0 1 .5]);
    
    h.h1Test = uicontrol('parent',h.Test,'style','pushbutton',style{:},...
        'position',[.725 .575 .225 .3],'backgroundcolor',[1 .75 .85],...
        'string','Run MARS','tag','test','callback',{@callMARS,gui});
    
    h.h2Test = uipanel('parent',h.Test,style{:},'position',[.025 .055 .7 .95],...
            'bordertype','none','title','New Testing data',...
            'fontangle','italic','foregroundcolor',[.5 .5 .5]);
    
    uicontrol('parent',h.h2Test,style{:},'style','text','position',[0 .825 .4 .1],...
            'string','Use classifiers:','horizontalalign','left');
    h.bhvrsTest = uicontrol('parent',h.h2Test,style{:},'style','listbox','position',[0 .2 .375 .65],...
            'string',classifier_list,'min',1,'max',length(classifier_list));

    uicontrol('parent',h.h2Test,style{:},'style','text','position',[0 .075 .4 .1],...
            'string','Ground truth?','horizontalalign','left');
    if(size(gui.annot.channels,2)>size(gui.annot.channels,1))
        gtStr = [{'--none--'} gui.annot.channels];
    else
        gtStr = [{'--none--'}; gui.annot.channels];
    end
    h.GT = uicontrol('parent',h.h2Test,style{:},'style','popupmenu','position',[0 0 .375 .1],...
            'string',gtStr);
    
    uicontrol('parent',h.h2Test,style{:},'style','text','position',[.4 .725 .3 .2],...
            'string','Test on trials:','horizontalalign','left');
    h.trialsTest = uicontrol('parent',h.h2Test,style{:},'style','listbox','position',[.4 0 .55 .85],...
            'string',trialList,'min',1,'max',length(trialList));

    h.h0 = gui.h0;
    guidata(hfig,h);
end


function toggleSubsetWindow(source,~)
    h = guidata(source);
    if(source.Value)
        set(h.h4Train,'visible','on');
    else
        set(h.h4Train,'visible','off');
    end
end

function toggleClfWindow(source,~)
    h = guidata(source);
    if(source.Value)
        set(h.h5Train,'visible','on');
    else
        set(h.h5Train,'visible','off');
    end
end

function updateMaskBehaviorOptions(source,~,gui)
    h   = guidata(source);
    ch  = h.maskChannel.String{h.maskChannel.Value};
    h.maskLabel.Value = 1;
    h.maskLabel.String = fieldnames(gui.data.annot.(ch));
end