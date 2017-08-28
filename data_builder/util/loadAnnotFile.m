function [annot,maxTime] = loadAnnotFile(fname,tmin,tmax)
if(nargin<2)
    tmin = 1;
    tmax = inf;
elseif(isstr(tmin))
    tmin = str2num(tmin);
    tmax = str2num(tmax);
end

fid = fopen(fname);
if(fid==-1)
    keyboard
end
M = textscan(fid,'%s','delimiter','\n'); M=M{1};
fclose(fid);

% get full list of labels
listend = find(strcmp(M,''));
listend = listend(2);
conf = M(4:listend-1);
for i = 1:length(conf)
    conf{i} = conf{i}(1:end-2);
    conf{i} = strrep(conf{i},'-','_');
    if(~isstrprop(conf{i}(1),'alpha'))
        conf{i} = ['x' conf{i}];
        M = strrep(M,conf{i}(2:end),conf{i});
    end
end

inds = [find(~cellfun(@isempty,strfind(M,'-----'))); length(M)+3];
annot = struct();
for i = 1:2
    str = ['Ch' num2str(i)];
    for b=1:length(conf)
        annot.(str).(conf{b}) = [];
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
        if(strcmpi(Mtemp{j,1},'other'))
            continue;
        end
        times = [Mtemp{j,2} Mtemp{j,3}];
        annot.(str).(Mtemp{j,1})   = [annot.(str).(Mtemp{j,1}); times];
    end
end