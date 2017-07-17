function Manager_callback(source,~,action)

h   = guidata(source);
errstr=[];
if(isempty(h.bhv.Value) && any(strcmpi({'rename','delete'},action)))
    errstr = ['Please select an annotation to ' action];
elseif(length(h.bhv.Value)>1 && strcmpi(action,'rename'))
    errstr = 'More than one annotation selected';
elseif(length(h.bhv.Value)<=1 && strcmpi(action,'merge'))
    errstr = 'Please select two or more annotations to merge';
end
if(~isempty(errstr))
    errordlg(errstr,'Error');
    return;
end
gui = h.gui;

switch action
    case 'add'
        answer          = inputdlg('Annotation to be added:','New annotation');
        if(isempty(answer)) return; end
        [answer,err]    = checkValid(answer,h.bhvMasterList);
        if(err) return; end
        h.bhvMasterList = [h.bhvMasterList; answer];
        gui = applyToAllMice(gui,'add',answer{:});

    case 'delete'
        inds    = h.bhv.Value;
        toKill  = h.bhv.String(inds);
        answer      = questdlg(['Confirm deletion of:  ' strjoin(toKill,', ')],'Confirm','Yes','No','Yes');
        if(strcmpi(answer,'no')) return; end
        h.bhvMasterList(inds) = [];
        gui = applyToAllMice(gui,'delete',toKill);
        
    case 'merge'
        inds    = h.bhv.Value;
        toMerge = h.bhv.String(inds);
        answer  = inputdlg({'Enter name of new (merged) annotation','Keep old annotations? (y/n)'},...
                           ['Merging behaviors ' strjoin(toMerge,' ')],1,{'','no'});
        if(isempty(answer)) return; end
        if(~any(strcmpi({'y','yes','n','no'},answer{2})))
            answer{2} = questdlg('Keep old annotations?', '???', 'Yes','No','No');
        end
        [answer{1},err] = checkValid(answer{1},setdiff(h.bhvMasterList,answer{1}));
        if(err) return; end
        
        inds    = inds(~strcmpi(toMerge,answer{1})); %don't delete the behavior we merge into
        toMerge = h.bhv.String(inds);
        
        if(~any(strcmpi(h.bhvMasterList,answer{1})))
            h.bhvMasterList = [h.bhvMasterList; answer(1)];
        end
        toKill = 0;
        if(any(strcmpi({'n','no'},answer{2})))
            h.bhvMasterList(inds)=[];
            toKill = 1;
        end
        gui = applyToAllMice(gui,'merge',toMerge,answer{1},toKill);
        
    case 'rename'
        ind             = h.bhv.Value;
        toEdit          = h.bhv.String(ind);
        answer          = inputdlg('Rename annotation:','Rename',1,toEdit);
        if(isempty(answer)) return; end
        [answer,err]    = checkValid(answer,h.bhvMasterList);
        if(err) return; end
        h.bhvMasterList(ind) = answer;
        gui = applyToAllMice(gui,'rename',toEdit{:},answer{:});
        
end

h.bhv.Value     = [];
h.bhv.String    = h.bhvMasterList;
h.gui           = gui;

guidata(source,h);
guidata(gui.h0,gui);


    function [answer,err] = checkValid(answer,bhvList)
        answer(ismember(answer,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
        answer = strrep(strtrim(answer),' ','_');
        
        err=0;
        if(isempty(answer))
            msgbox('Name must be at least one character long (special characters are removed.)');
            err=1;
        end
        if(any(strcmpi(bhvList,answer)))
            msgbox('A label with that name already exists.');
            err=1;
        end
    end

end