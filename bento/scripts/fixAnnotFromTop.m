function fixAnnotFromTop(pth)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



doubleStepBack=0; %change this to 1 to do a broader search for corresponding movies

if(~exist('pth','var'))
    pth = uigetdir(pwd,'Select directory to convert');
end
pth(end) = strrep(pth(end),'/','');
pth(end) = strrep(pth(end),'\','')

files = dir([pth filesep '**' filesep '*.annot']);
drop = find(~cellfun(@isempty,strfind({files.name},'_TS.annot')));
files(drop)=[];
files2 = dir([pth filesep '**' filesep '*.txt']);
files = [files;files2];

ans = questdlg(['Found ' num2str(length(files)) ' files. Continue?'],'Converting frames to times','Yes','No','Yes');
if(strcmpi(ans,'No'))
    return;
end

for f = 1:length(files)
    disp([num2str(f) '/' num2str(length(files))]);
    fname = [files(f).folder filesep files(f).name];
    [~,~,ext] = fileparts(fname);

    if(strcmpi(ext,'.txt'))
        mov = regexprep(fname,'_[a-z_]*actions_pred_v[0-9]*_[0-9]*.txt','_Top.seq');
%         mov = regexprep(fname,'_[A-Z]*.txt','_Top.seq');
        [pth,mov] = fileparts(mov);
        pth = fileparts(fileparts(pth));
        mov = [pth filesep mov '.seq'];
        if(~exist(mov,'file'))
            disp('Couldn''t find movie! Looked in:');
            disp(['    ' mov]);
            continue;
        end
        stim = '';
        movieNames = mov;
    else
        % first try getting the movie name from the annot file:
        fid     = fopen(fname);
        tline   = fgetl(fid);
        clear movieNames stim;
        for i=1:2
            movieNames = tline;
            tline = fgetl(fid);
        end
        for i=1:2
            stim = tline;
            tline = fgetl(fid);
        end
        fclose(fid);
        stim = strrep(stim,'Stimulus name: ','');
        mov = strsplit(strrep(movieNames,'Movie file(s):  ',''),'.seq');
        mov = [mov{find(~cellfun(@isempty,strfind(mov,'Top')))} '.seq'];

        % if that fails, look for a movie with a compatible name
        if(isempty(strrep(mov,'.seq','')) || ~exist(mov,'file'))
            if(isempty(strrep(mov,'.seq','')))
                disp(['No movie info provided in ' fname '; searching based on filename...']);
            end
            [~,mov2] = fileparts(mov);
            mov2 = strrep(mov2,'Mouse_','');
            mov2 = regexprep(mov2,'_[a-z_]*actions_pred_v[0-9]*_[0-9]*','');

            mov2 = dir([fileparts(files(f).folder) filesep '*' mov2 '*.seq']);
            if(doubleStepBack)
                mov2 = dir([fileparts(fileparts(files(f).folder)) filesep '**/*' mov2 '*.seq']);
            end
            if(isempty(mov2))
                disp([mov ' could not be found!']);
                continue;
            else
                disp(['found a match ' mov2(1).name]);
                mov = [mov2(1).folder filesep mov2(1).name];
            end
        end
    end

    disp(['   getting timestamps for ' mov '...']);
    temp    = seqIo(mov,'reader');
    TS        = getSeqTimestamps(mov,temp);

    disp('   fixing annotations...');
    [annot,tmax,tmin,FR] = loadAnyAnnot(fname);
    if(isnan(FR))
        FR=30;
    end
    TS      = TS - TS(tmin);
    for ch = fieldnames(annot)'
        for b = fieldnames(annot.(ch{:}))'
            if(~isempty(annot.(ch{:}).(b{:})))
                annot.(ch{:}).(b{:}) = TS(min(annot.(ch{:}).(b{:}),length(TS)));
            end
        end
    end
    disp('   saving...');
    clear trial;
    fname = strrep(fname,'.annot','_TS.annot');
    fname = strrep(fname,'.txt','_TS.annot');
    trial.io.annot.fid  = {fname};
    trial.io.annot.tmin = tmin;
    trial.io.annot.tmax = tmax;
    trial.io.annot.FR   = FR;
    trial.annoFR        = FR;
    trial.stim          = stim;
    trial.annot         = annot;
    saveAnnotSheetTxt({movieNames},trial,[],1);
    disp('   done!');
end




