function saveAnnotSheetTxt(gui,trial,mouse,session,tr)

fid     = trial.io.annot.fid;
tmin    = trial.io.annot.tmin;
tmax    = trial.io.annot.tmax;

if(isempty(fid)|strcmpi(fid(end-10:end),'blank.annot')|~strcmpi(fid(end-5:end),'.annot')) %need to create a new file
    suggestedName = ['mouse' num2str(mouse) '_' session '_' num2str(tr,'%03d') '.annot'];
    [fname,pth] = uiputfile(suggestedName);
    fid = [pth fname];
end
fid = fopen(fid,'w');
% write metadata-----------------------------------------------------------
fprintf(fid,'%s\n','Tracergui annotation file');
if(gui.enabled.movie(1))
    nmov = length(trial.io.movie.fid);
    fstr = '%s ';
    for m = 1:nmov
        fstr = [fstr '%s '];
    end
    fstr = [fstr '\n'];
    fprintf(fid,fstr,'Movie file(s): ',trial.io.movie.fid{:});
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