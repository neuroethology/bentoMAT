function newStr = addNewFieldPopup(prompt,default)
    newStr  = inputdlg(prompt,'',1,default);
    if(isempty(newStr))
        return;
    end
    
    % make sure that the new name is legit
    newStr = newStr{1};
    newStr(ismember(newStr,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
    newStr = strrep(newStr,' ','_');
    if(isempty(newStr))
        uiwait(msgbox('Name must be at least one character long.'));
    end
end