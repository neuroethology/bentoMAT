function saveAnnotSheetTxt(movieNames,trial,suggestedName)

fid     = trial.io.annot.fidSave{:};
tmin    = trial.io.annot.tmin;
tmax    = trial.io.annot.tmax;

%always prompt the save path?
if(isempty(fid)|strcmpi(fid(end-10:end),'blank.annot')|~strcmpi(fid(end-5:end),'.annot')) %need to create a new file
    if(isempty(suggestedName))
        suggestedName = 'annotations';
    end
    [fname,pth] = uiputfile([pth filesep suggestedName]);
    fid = [pth fname];
else
    [fname,pth] = uiputfile(fid);
    fid = [pth fname];
end

fid = fopen(fid,'w');
% write metadata-----------------------------------------------------------
fprintf(fid,'%s\n','Tracergui annotation file');
if(~isempty(movieNames))
    nmov = length({movieNames{:}});
    fstr = '%s ';
    for m = 1:nmov
        fstr = [fstr '%s '];
    end
    fstr = [fstr '\n'];
    fprintf(fid,fstr,'Movie file(s): ',movieNames{:});
end
fprintf(fid,'\n');
fprintf(fid,'%s %s\n','Stimulus name:',trial.stim);
fprintf(fid,'%s %d\n','Annotation start frame:',tmin);
fprintf(fid,'%s %d\n','Annotation stop frame:',tmax);

fprintf(fid,'\n%s\n','List of channels:');
channels = fieldnames(trial.annot);
for i=1:length(channels)
    fprintf(fid,'%s\n',channels{i});
end
fprintf(fid,'\n');

fprintf(fid,'%s\n','List of annotations:');
labels   = fieldnames(trial.annot.(channels{1}));
for i=1:length(labels)
    fprintf(fid,'%s\n',labels{i});
end
fprintf(fid,'\n');

% write each channel-------------------------------------------------------
for c = 1:length(channels)
    Ch = channels{c};
    
    [M,summaries.(Ch)] = makeBehaviorSummary(trial.annot.(Ch),tmin,tmax);
    if(isempty(M))
        M{1,1} = '';
        continue;
    end
    
    fprintf(fid,'%s----------\n',channels{c});
    for beh = 1:3:size(M,2)
        fprintf(fid,'>%s\n',M{1,beh});
        fprintf(fid,'%s\t %s\t %s \n','Start','Stop','Duration');
        for i = 3:size(M,1)
            if(isempty(M{i,beh}))
                continue;
            end
            fprintf(fid,'%d\t%d\t%d\n',M{i,beh},M{i,beh+1},M{i,beh+2});
        end
        fprintf(fid,'\n');
    end
	fprintf(fid,'\n');
end

fclose(fid);