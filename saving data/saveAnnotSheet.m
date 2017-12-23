function saveAnnotSheet(gui,trial,mouse,session,tr)

fid     = trial.io.annot.fid;
tmin    = trial.io.annot.tmin;
tmax    = trial.io.annot.tmax;

if(isempty(fid)|~isempty(strfind(fid,'blank'))) %need to create a new excel sheet
    suggestedName = ['mouse' num2str(mouse) '_' session '_' num2str(tr,'%03d') '.xlsx'];
    [fname,pth] = uiputfile(suggestedName);
    fid = [pth fname];
else
    if(exist(fid,'file'))
        delete(fid);
    end
end

% write metadata/summary to info sheet-------------------------------------
info = {};
info{1,1} = 'Annotation datasheet';
if(gui.enabled.movie(1))
    info{2,1} = 'Movie file:';
    info{2,2} = trial.io.movie.fid;
end
info{3,1} = 'Stimulus name:';
info{3,2} = trial.stim;
info{4,1} = 'Annotation start frame:';
info{4,2} = tmin;
info{5,1} = 'Annotation stop frame:';
info{5,2} = tmax;

info{7,1} = 'List of channels:';
info{7,3} = 'List of annotations:';

channels = fieldnames(trial.annot);
labels   = fieldnames(trial.annot.(channels{1}));
cmap     = gui.annot.cmap;

info(7+(1:length(channels)),1) = channels;
info(7+(1:length(labels)),3) = labels;

bump = size(info,1)+2;
% write each channel to its own sheet----------------------------------
for c = 1:length(channels)
    Ch = channels{c};
    
    [M,summaries.(Ch)] = makeBehaviorSummary(trial.annot.(Ch),tmin,tmax);
    if(isempty(M))
        M{1,1} = '';
    end
    xlswrite(fid,M,Ch);

    % add summary data for each channel/behavior to the info sheet
    info{bump,1} = ['Summary statistics for channel ' Ch];
    bump=bump+1;
    info(bump,1:6) = {'Behavior','','% time','# bouts','mean duration','latency to first bout'};
    if(~isempty(summaries.(Ch)))
        info(bump+(1:size(summaries.(Ch),1)),1:6) = summaries.(Ch);
        bump = bump + size(summaries.(Ch),1) - 1;
    else
        info{bump+1,1} = 'none annotated';
    end
    bump = bump + 3;
end

xlswrite(fid,info,'info');

% Delete stray sheets------------------------------------------------------
[~,sheetlist] = xlsfinfo(fid);
toDrop = setdiff(sheetlist,{channels{:} 'info'});
if(~isempty(toDrop))
    for i=1:length(toDrop)
        objExcel = actxserver('Excel.Application');
        objExcel.DisplayAlerts = false;
        WB = objExcel.Workbooks.Open(fid);
        try
              WB.Worksheets.Item(toDrop{i}).Delete;
        catch
            disp(['warning: extra sheet ' toDrop{i} ' coud not be deleted']);
        end
        WB.Save();
        WB.Close();
        objExcel.Quit();
        delete(objExcel);
    end
end