function save_summary_rasters(pth,filter,includeMARSOutput,overridePrompt)

cmapDef = loadPreferredCmap();

% find files
disp(['Locating annotation files [' pth '**' filesep filter ']...'])
files = rdir([pth '**' filesep filter]);
if(~exist('includeMARSOutput','var') || ~includeMARSOutput)
    drop = ~cellfun(@isempty,strfind({files.folder},'output_v1_')) ...
            & ~cellfun(@isempty,strfind({files.name},'actions_pred')) ...
            & strcmpi(cellfun(@(x) x(end-2:end),{files.name},'uniformoutput',false),'txt');
    files(drop) = [];
end

% prompt to continue (if not overriden)
if(~exist('overridePrompt','var') || ~overridePrompt)
    ans = questdlg(['Found ' num2str(length(files)) ' files. Continue with summary?'],'Done!',...
                    'Yes','No','Yes');
    if(strcmpi(ans,'No'))
        return;
    end
else
    disp(['Found ' num2str(length(files)) ' files. Saving plots...']);
end

% remove previously generated pdfs
if(ls([pth 'annotations_summary.pdf']))
    delete([pth 'annotations_summary.pdf']);
end

% make/save plots!
img = [];
h   = figure(2);clf;
for f = 1:length(files)
    disp([num2str(f) '/' num2str(length(files))]);
    clf;
    fname           = files(f).name;
    [annot,maxTime] = loadAnyAnnot(fname);

    if(~isempty(annot))
        make_behavior_raster_summary(annot,cmapDef,maxTime,h,strrep(fname,pth,''));
        im = getframe(h);
        img = cat(1,img,im.cdata);
        export_fig([pth 'all_mice_summary.pdf'],'-pdf','-append','-painters');
    end
end
imwrite(img,[pth 'all_mice_summary.png']);
close(h);

