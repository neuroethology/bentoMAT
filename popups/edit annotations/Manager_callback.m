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
        [answer,err]    = checkValid(answer);
        if(err) return; end
        h.bhvMasterList = [h.bhvMasterList answer];
        gui = applyToAllMice(gui,'add',answer);

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
        [answer{1},err] = checkValid(answer{1});
        if(err) return; end
        
        if(~any(strcmpi({'y','yes','n','no'},answer{2})))
            answer{2} = questdlg('Keep old annotations?', '???', 'Yes','No','No');
        end
        h.bhvMasterList = [h.bhvMasterList; answer(1)];
        toKill = 1;
        if(strcmpi(answer{2},'n')|strcmpi(answer{2},'no'))
            h.bhvMasterList(inds)=[];
            toKill = 0;
        end
        gui = applyToAllMice(gui,'merge',toMerge,answer{1},toKill);
        
    case 'rename'
        ind             = h.bhv.Value;
        toEdit          = h.bhv.String(ind);
        answer          = inputdlg('Rename annotation:','Rename',1,toEdit);
        [answer,err]    = checkValid(answer);
        if(err) return; end
        h.bhvMasterList(ind) = answer;
        gui = applyToAllMice(gui,'rename',toEdit{:},answer{:});
        
end

h.bhv.Value     = [];
h.bhv.String    = h.bhvMasterList;
h.gui           = gui;

guidata(source,h);
guidata(gui.h0,gui);


    function [answer,err] = checkValid(answer)
        answer(ismember(answer,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
        answer = strrep(strtrim(answer),' ','_');
        
        err=0;
        if(isempty(answer))
            msgbox('Name must be at least one character long (special characters are removed.)');
            err=1;
        end
    end

end