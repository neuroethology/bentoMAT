function filename = saveAnnotSheetTxt(movieNames,trial,suggestedName,promptOverride,timeFlag)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



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
    filename = [pth fname];
elseif(exist('promptOverride','var') && ~promptOverride)
    [fname,pth] = uiputfile(fid);
    filename = [pth fname];
else
    filename = fid;
end

% set a default value of timeFlag
if(~exist('timeFlag','var'))
    timeFlag = false;
end


%check to see if the framerate was changed for display, and change back if so
if(FR~=trial.annoFR)
    for ch = fieldnames(trial.annot)'
        for beh = fieldnames(trial.annot.(ch{:}))'
            trial.annot.(ch{:}).(beh{:}) = round(trial.annot.(ch{:}).(beh{:}) * FR/trial.annoFR);
        end
    end
end

annot = trial.annot;
stim  = trial.stim;
saveAnnot(filename,annot,tmin,tmax,FR,movieNames,stim,timeFlag);



