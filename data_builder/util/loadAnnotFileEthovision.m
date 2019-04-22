function [annot,tmax] = loadAnnotFileEthovision(M)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



M(cellfun(@isempty,M)) = [];

ind_cmd = find(~cellfun(@isempty,strfind(M,'COMMAND SET')));
ind_cmd_stop = find(~cellfun(@isempty,strfind(M,'--')));
ind_cmd_stop(ind_cmd_stop<ind_cmd) = [];
ind_cmd_stop = ind_cmd_stop(3);

labels = regexp(M(ind_cmd+4:ind_cmd_stop-1),' {2,}','split');
labels = cat(1,labels{:});
labels = [labels(:,1) labels(:,end)];
for i = 1:length(labels)
    labels{i,1} = labels{i,1}(labels{i,1}~=char(10));
end
labels = strrep(labels,' ','_');

ind_start = find(~cellfun(@isempty,strfind(M,'RAW LOG')));
ind_stop  = find(~cellfun(@isempty,strfind(M,'FULL LOG')));
M = regexp(M(ind_start+4:ind_stop-2),' *','split');
if(length(M{1})==4)
    M{1} = M{1}(2:end);
end
M = cat(1,M{:});
M = [M(:,end) num2cell(cellfun(@str2num,M(:,1)))];
Mactions = M;
Mactions([Mactions{:,1}]=='l',:)=[];
Mactions([Mactions{:,1}]=='k',:)=[];
Mactions([Mactions{:,1}]=='r',:)=[];

tmax = max([M{:,2}]);

annot.Ch1 = struct();
ratIn = find([M{:,1}]=='r');
annot.Ch2.rat = [M{ratIn,2} tmax];
for i = 1:length(Mactions)
    if(strcmpi(Mactions{i,1},'s'))
        tStop = Mactions{i,2}-1;
        if(~isfield(annot.Ch1,labels{b,2}))
            annot.Ch1.(labels{b,2}) = [tStart tStop];
        else
            annot.Ch1.(labels{b,2}) = [annot.Ch1.(labels{b,2}); tStart tStop];
        end
    else
        tStart = Mactions{i,2};
        b = find(strcmpi(labels(:,1),Mactions{i,1}));
    end
end
