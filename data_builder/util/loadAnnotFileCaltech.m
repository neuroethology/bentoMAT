function [annot,maxTime,hotkeys] = loadAnnotFileCaltech(M,tmin,tmax)

% get full list of labels
listend = find(strcmp(M,''));
listend = listend(2);
labelList = M(4:listend-1);
hotkeys = struct();
for i = 1:length(labelList)
    labelList{i} = strtrim(labelList{i});
    
    if(~isstrprop(labelList{i}(1),'alpha'))
        labelList{i}=['w' labelList{i}];
    end
    hotkeys.(strrep(labelList{i}(1:end-2),'-','_')) = labelList{i}(end);
    labelList{i} = labelList{i}(1:end-2);
    labelList{i} = strrep(labelList{i},'-','_');
    if(~isstrprop(labelList{i}(1),'alpha'))
        labelList{i} = ['x' labelList{i}];
        M = strrep(M,labelList{i}(2:end),labelList{i});
    end
end

inds = [find(~cellfun(@isempty,strfind(M,'-----'))); length(M)+3];
annot = struct();
for i = 1:2
    str = ['Ch' num2str(i)];
    for b=1:length(labelList)
        annot.(str).(labelList{b}) = [];
    end
end

if(isinf(tmax))
    Mtemp = regexp(M((inds(1)+1):(inds(2)-3)),'(\S+)','match'); Mtemp = cat(1,Mtemp{:});
    maxTime = str2num(Mtemp{end,2});
else
    maxTime = tmax-tmin+1;
end
for i = 1:2
    str = ['Ch' num2str(i)];
    Mtemp = regexp(M((inds(i)+1):(inds(i+1)-3)),'(\S+)','match');
    Mtemp = cat(1,Mtemp{:});
    Mtemp = [Mtemp(:,end) num2cell(cellfun(@str2num,Mtemp(:,1))) num2cell(cellfun(@str2num,Mtemp(:,2)))];
    
    Mtemp(cat(1,Mtemp{:,2})>tmax,:) = [];
    Mtemp{end,3} = min(Mtemp{end,3},tmax);
	Mtemp(:,2) = num2cell(max((cat(1,Mtemp{:,2})-tmin+1),1));
    Mtemp(:,3) = num2cell(max((cat(1,Mtemp{:,3})-tmin+1),1));
    Mtemp(cat(1,Mtemp{:,3})<=1,:) = [];
    
    Mtemp(:,1) = strrep(Mtemp(:,1),'-','_');
    for j = 1:size(Mtemp,1)
%         if(strcmpi(Mtemp{j,1},'other'))
%             continue;
%         end
        times = [Mtemp{j,2} Mtemp{j,3}];
        if(~isstrprop(Mtemp{j,1}(1),'alpha'))
            Mtemp{j,1} = ['w'  Mtemp{j,1}];
        end
        annot.(str).(Mtemp{j,1})   = [annot.(str).(Mtemp{j,1}); times];
    end
end