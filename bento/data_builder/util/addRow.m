function addRow(source,~,copyFlag)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui = guidata(source);
dat = get(gui.t,'data');

if(copyFlag)
    newTable = dat;
    copyInds = gui.t.UserData(:,1);
    
    for i = 1:length(copyInds)
        ind = copyInds(i);
        newTable(ind+1:end+1,:) = newTable(ind:end,:);
        sameSession = ind + find(([newTable{ind+1:end,1}] == newTable{ind,1}) & ...
                                 ([newTable{ind+1:end,2}] == newTable{ind,2}));
        newTable(sameSession,3) = num2cell(cellfun(@(x) x+1, newTable(sameSession,3)));
        copyInds(i+1:end) = copyInds(i+1:end)+1;
    end
    
    dat = newTable;
    
else
    dat(end+1,4)  = {''};
    dat{end,1}    = dat{end-1,1};
    dat{end,2}    = dat{end-1,2};
    dat{end,3}    = dat{end-1,3}+1;
    dat(end,5:16) = {[]};
    txt           = [5 9 10 15 16];
    dat(end,txt)  = {''};
end

set(gui.t,'data',dat);
guidata(source,gui);