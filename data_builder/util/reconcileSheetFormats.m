function [M,matches] = reconcileSheetFormats(gui,raw,fset)

if(~isempty(gui))
    matchset = get(gui.t,'columnname');
else %hacks~
    matchset = {'Mouse','Sessn','Trial','Stim','Calcium imaging file','Start Ca',...
                'Stop Ca','FR Ca','Alignments','Annotation file','Start Anno','Stop Anno',...
                'FR Anno','Offset','Behavior movie','Tracking','Audio file'};
end
matchset = strrep(matchset,' ','_');
matchset = strrep(matchset,'_#','');

matches = struct();
for i=1:length(matchset)
    str = strrep(matchset{i},' ','_');
    str = strrep(str,'_#','');
    matches.(str) = i;
end

nodata = find(isnan([raw{3:end,1}]))+2;
raw(nodata,:) = [];

[startFlag,stopFlag,FRFlag]=deal(0);
for f = 1:length(fset)
    ind = find(~cellfun(@isempty,strfind(matchset,fset{f})));
    if(length(ind)>1)
        switch fset{f}
            case 'Start'
                if(startFlag)
                    ind = find(~cellfun(@isempty,strfind(matchset,'Start_Anno')));
                else
                    ind = find(~cellfun(@isempty,strfind(matchset,'Start_Ca')));
                    startFlag = 1;
                end
            case 'Stop'
                if(stopFlag)
                    ind = find(~cellfun(@isempty,strfind(matchset,'Stop_Anno')));
                else
                    ind = find(~cellfun(@isempty,strfind(matchset,'Stop_Ca')));
                    stopFlag = 1;
                end
            case 'FR'
                if(FRFlag)
                    ind = find(~cellfun(@isempty,strfind(matchset,'FR_Anno')));
                else
                    ind = find(~cellfun(@isempty,strfind(matchset,'FR_Ca')));
                    FRFlag = 1;
                end
        end
    end
    M(:,ind(1)) = raw(3:end,f);
end

%append blank columns for unreported fields
for i = 1:(length(matchset)-size(M,2))
    M(:,end+1)={[]};
end
    