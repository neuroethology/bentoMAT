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

    close(figure(9876));
    hfig = figure(9876);clf;
    style = {'units','normalized','fontsize',10};

    set(hfig,'dockcontrols','off','menubar','none',...
        'NumberTitle','off','Position', hfig.Position.*[.75 .75 1.45 1.25],...
        'units','normalized','Tag','trainMARS');
    
% Training panel-----------------------------------------------------------
    h.Train = uipanel('parent',hfig,style{:},'position',[0 .5 1 .5]);

    h.h1Train = uicontrol('parent',h.Train,'style','pushbutton',style{:},...
        'position',[.725 .575 .225 .3],'backgroundcolor',[.65 1 .65],...
        'string','Train MARS','tag','train','callback',{@callMARS,gui});
    
    h.evalTrain = uicontrol('parent',h.Train,'style','checkbox',style{:},...
        'position',[.75 .4 .225 .15],'string','Run on training set','value',1);

%     bg = uibuttongroup('parent',h.Train,'position',[.75 .3 .225 .2],'bordertype','none');
%     uicontrol('parent',bg,'style','radiobutton',style{:},'string','Use full trial duration',...
%               'position',[0 .5 1 .5],'callback',{@toggleSubsetWindow,0});
%     uicontrol('parent',bg,'style','radiobutton',style{:},'string','Use select trial times',...
%               'position',[0 0 1 .5],'callback',{@toggleSubsetWindow,1});


    h.h2Train = uipanel('parent',h.Train,style{:},'position',[.025 .055 .7 .95],...
            'bordertype','none','title','New training data',...
            'fontangle','italic','foregroundcolor',[.5 .5 .5]);

    uicontrol('parent',h.h2Train,style{:},'style','text','position',[0 .825 .4 .1],...
            'string','Train behavior:','horizontalalign','left');
    h.bhvrsTrain = uicontrol('parent',h.h2Train,style{:},'style','popupmenu','position',[0 .75 .375 .1],...
            'string',fieldnames(gui.annot.bhv));
    
    uicontrol('parent',h.h2Train,style{:},'style','text','position',[0 .625 .4 .1],...
            'string','Train from channels:','horizontalalign','left');
    h.chsTrain = uicontrol('parent',h.h2Train,style{:},'style','listbox','position',[0 0 .375 .65],...
            'string',gui.annot.channels,'min',1,'max',length(gui.annot.channels));

    uicontrol('parent',h.h2Train,style{:},'style','text','position',[.4 .725 .3 .2],...
            'string','Train from trials:','horizontalalign','left');
    h.trialsTrain = uicontrol('parent',h.h2Train,style{:},'style','listbox','position',[.4 0 .55 .85],...
            'string',trialList,'min',1,'max',length(trialList));
    
    h.h3Train = uipanel('parent',h.Train,style{:},'position',[.55 .055 .15 .95],...
            'bordertype','none','title','New training data',...
            'fontangle','italic','foregroundcolor',[.5 .5 .5],'visible','off');
    uicontrol('parent',h.h3Train,style{:},'style','text','position',[0 .725 1 .2],...
            'string','Train window:','horizontalalign','left');
    uicontrol('parent',h.h3Train,style{:},'style','listbox','position',[0 0 1 .85],...
            'string',fieldnames(gui.annot.bhv),'min',1,'max',1);
        
        
% Testing panel------------------------------------------------------------
    h.Test = uipanel('parent',hfig,style{:},'position',[0 0 1 .5]);
    
    h.h1Test = uicontrol('parent',h.Test,'style','pushbutton',style{:},...
        'position',[.725 .575 .225 .3],'backgroundcolor',[1 .75 .85],...
        'string','Run MARS','tag','test','callback',{@callMARS,gui});
    
    h.h2Test = uipanel('parent',h.Test,style{:},'position',[.025 .055 .7 .95],...
            'bordertype','none','title','New Testing data',...
            'fontangle','italic','foregroundcolor',[.5 .5 .5]);
    
    classifier_list         = ls([path_to_MARS 'Bento_temp/']);
    classifier_list(1:2,:)  = [];
    classifier_list = strrep(cellstr(classifier_list),'.dill','*');
    temp        = ls([path_to_MARS 'Bento/']);
    temp(1:2,:) = [];
    classifier_list = [classifier_list; strrep(cellstr(temp),'.dill','')];
    
    uicontrol('parent',h.h2Test,style{:},'style','text','position',[0 .825 .4 .1],...
            'string','Use classifiers:','horizontalalign','left');
    h.bhvrsTest = uicontrol('parent',h.h2Test,style{:},'style','listbox','position',[0 .2 .375 .65],...
            'string',classifier_list,'min',1,'max',length(classifier_list));

    uicontrol('parent',h.h2Test,style{:},'style','text','position',[0 .075 .4 .1],...
            'string','Ground truth?','horizontalalign','left');
    h.GT = uicontrol('parent',h.h2Test,style{:},'style','popupmenu','position',[0 0 .375 .1],...
            'string',[{'--none--'}; gui.annot.channels]);
    
    uicontrol('parent',h.h2Test,style{:},'style','text','position',[.4 .725 .3 .2],...
            'string','Test on trials:','horizontalalign','left');
    h.trialsTest = uicontrol('parent',h.h2Test,style{:},'style','listbox','position',[.4 0 .55 .85],...
            'string',trialList,'min',1,'max',length(trialList));

    h.h0 = gui.h0;
    guidata(hfig,h);
end


function toggleSubsetWindow(source,~,toggle)
    h = guidata(source);
    if(toggle)
        set(h.h3,'visible','on');
        set(h.h2,'position',[.025 .055 .54 .95]);
    else
        set(h.h3,'visible','off');
        set(h.h2,'position',[.025 .055 .7 .95]);
    end
end