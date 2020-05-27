function saveAnnot(filename,annot,tmin,tmax,FR,movieNames,stim,timeFlag)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

% set a default value of timeFlag
if(~exist('timeFlag','var'))
    timeFlag = false;
end

fid = fopen(filename,'w');
% write metadata-----------------------------------------------------------
fprintf(fid,'%s\n','Bento annotation file');
if(~isempty(movieNames))
    nmov = length({movieNames{:}});
    fstr = '%s ';
    for m = 1:nmov
        fstr = [fstr '%s '];
    end
    fstr = [fstr '\n'];
    fprintf(fid,fstr,'Movie file(s): ',movieNames{:});
else
    fprint(fid,'Movie file(s): \n');
end
fprintf(fid,'\n');
fprintf(fid,'%s %s\n','Stimulus name:',stim);
fprintf(fid,'%s %d\n','Annotation start frame:',tmin);
fprintf(fid,'%s %d\n','Annotation stop frame:',tmax);
fprintf(fid,'%s %f\n','Annotation framerate:',FR);

fprintf(fid,'\n%s\n','List of channels:');
channels = fieldnames(annot);
labels = {};
for i=1:length(channels)
    fprintf(fid,'%s\n',channels{i});
    labels   = [labels; fieldnames(annot.(channels{i}))];
end
fprintf(fid,'\n');

fprintf(fid,'%s\n','List of annotations:');
labels = unique(labels);
for i=1:length(labels)
    fprintf(fid,'%s\n',labels{i});
end
fprintf(fid,'\n');

% write each channel-------------------------------------------------------
for c = 1:length(channels)
    Ch = channels{c};
    
    [M,summaries.(Ch)] = makeBehaviorSummary(annot.(Ch),tmin,tmax,FR,timeFlag);
    if(isempty(M))
        M{1,1} = '';
        continue;
    end
    %convert from frames to times, to avoid future tragedies
    if(~any(cellfun(@any,cellfun(@(x)rem(x,1),{M{:}},'uniformOutput',false))))
        M(cellfun(@isnumeric,M)) = cellfun(@(x) x/FR,M(cellfun(@isnumeric,M)),'uniformoutput',false);
    end
    
    fprintf(fid,'%s----------\n',channels{c});
    for beh = 1:3:size(M,2)
        fprintf(fid,'>%s\n',M{1,beh});
        fprintf(fid,'%s\t %s\t %s \n','Start','Stop','Duration');
        for i = 3:size(M,1)
            if(isempty(M{i,beh}))
                continue;
            end
            fprintf(fid,'%.12g\t%.12g\t%.12g\n',M{i,beh},M{i,beh+1},M{i,beh+2});
        end
        fprintf(fid,'\n');
    end
	fprintf(fid,'\n');
end

fclose(fid);