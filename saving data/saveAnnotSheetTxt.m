function filename = saveAnnotSheetTxt(movieNames,trial,suggestedName)

if(~isempty(trial.io.annot.fid))
    fid     = trial.io.annot.fid{:};
else
    fid = [];
end
tmin    = trial.io.annot.tmin;
tmax    = trial.io.annot.tmax;
FR      = trial.io.annot.FR;

% should prompt channels to save (if it's not quicksave)? also, should save
% channels to the appropriate source file

%always prompt the save path?
if(isempty(fid)|strcmpi(fid(end-10:end),'blank.annot')|~strcmpi(fid(end-5:end),'.annot')) %need to create a new file
    if(isempty(suggestedName))
        suggestedName = [pwd filesep 'annotations'];
    end
    [fname,pth] = uiputfile(suggestedName);
else
    [fname,pth] = uiputfile(fid);
end
filename = [pth fname];

%check to see if the framerate was changed for display, and change back if so
if(FR~=trial.annoFR)
    for ch = fieldnames(trial.annot)'
        for beh = fieldnames(trial.annot.(ch{:}))'
            trial.annot.(ch{:}).(beh{:}) = round(trial.annot.(ch{:}).(beh{:}) * FR/trial.annoFR);
        end
    end
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
end
fprintf(fid,'\n');
fprintf(fid,'%s %s\n','Stimulus name:',trial.stim);
fprintf(fid,'%s %d\n','Annotation start frame:',tmin);
fprintf(fid,'%s %d\n','Annotation stop frame:',tmax);
fprintf(fid,'%s %f\n','Annotation framerate:',FR);

fprintf(fid,'\n%s\n','List of channels:');
channels = fieldnames(trial.annot);
labels = {};
for i=1:length(channels)
    fprintf(fid,'%s\n',channels{i});
    labels   = [labels; fieldnames(trial.annot.(channels{i}))];
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