function [annot,tmax] = loadAnnotSheet(fname,tmin,tmax)
% still need to add support for multiple annotations for file
if(nargin<2)
    tmin = nan;
    tmax = nan;
elseif(isstr(tmin))
    tmin = str2num(tmin);
    tmax = str2num(tmax);
end

[~,~,info]      = xlsread(fname,'info');
[~,sheetlist]   = xlsfinfo(fname);

if(isnan(tmin))
    tmin = info{4,2};
    tmax = info{5,2};
    if(isstr(tmin))
        tmin = str2num(tmin);
        tmax = str2num(tmax);
    end
end

listend  = find(cellfun(@any,cellfun(@isnan,info(:,1),'uniformoutput',false)));
listend(listend<8)=[];
channels = info(8:listend(1),1);
channels = channels(cellfun(@isstr,channels));

listend  = find(cellfun(@any,cellfun(@isnan,info(:,3),'uniformoutput',false)));
listend(listend<8)=[];
labels   = info(8:listend(1),3);
labels   = labels(cellfun(@isstr,labels));

if(~isempty(setdiff(sheetlist,{channels{:} 'info'})))
    disp(['Found sheet ''' c{:} ''' in the excel file that was not '...
          'mentioned on the info sheet! This data will not be loaded.']);
end

annot = struct();
for c = channels'
    for f = labels'
        annot.(c{:}).(f{:}) = [];
    end
    if(~any(strcmpi(sheetlist,c{:})))
        disp(['Did not find a sheet for channel ' c{:} '; a blank channel with this name will be created.']);
        continue;
    end
    [~,~,data]  = xlsread(fname,c{:});
    if(size(data,1)>2) % protect from blank sheets- shouldn't happen, but sometimes seems to?
        populated = data(1,cellfun(@isstr,data(1,:)));
    else
        populated = [];
    end
    for f = 1:length(populated)
        dsub = cell2mat(data(3:end,(f-1)*3+(1:2)));
        dsub(isnan(dsub(:,1)),:) = [];
        annot.(c{:}).(populated{f}) = dsub;
    end
end
