function fixAnnotFromTop(pth)

doubleStepBack=0; %change this to 1 to do a broader search for corresponding movies

if(~exist('pth','var'))
    pth = uigetdir(pwd,'Select directory to convert');
end
pth(end) = strrep(pth(end),'/','');
pth(end) = strrep(pth(end),'\','')

files = dir([pth '\**\*.annot']);
drop = find(~cellfun(@isempty,strfind({files.name},'_TS.annot')));
files(drop)=[];

ans = questdlg(['Found ' num2str(length(files)) ' annot files. Continue?'],'Converting frames to times','Yes','No','Yes');
if(strcmpi(ans,'No'))
    return;
end

for f = 1:length(files)
    disp([num2str(f) '/' num2str(length(files))]);
    fname = [files(f).folder filesep files(f).name];

% get the movie and stim names
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

    if(isempty(strrep(mov,'.seq','')))
        disp(['No movie info for ' fname]);
        continue;
    end
    if(~exist(mov,'file'))
        [~,mov2] = fileparts(mov);
        mov2 = strrep(mov2,'Mouse_','');
        mov2 = dir([fileparts(files(f).folder) filesep '*' mov2 '*.seq']);
        if(doubleStepBack)
            mov2 = dir([fileparts(fileparts(files(f).folder)) filesep '**/*' mov2 '*.seq']);
        end
        if(isempty(mov2))
            disp([mov ' could not be found!']);
            continue;
        else
            mov = [mov2(1).folder filesep mov2(1).name];
        end
    end

    disp(['   getting timestamps for ' mov '...']);
    temp    = seqIo(mov,'reader');
    TS      = temp.getts();

    disp('   fixing annotations...');
    [annot,tmin,tmax,FR] = loadAnnotSheetTxt(fname);
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
    trial.io.annot.fid  = {strrep(fname,'.annot','_TS.annot')};
    trial.io.annot.tmin = tmin;
    trial.io.annot.tmax = tmax;
    trial.io.annot.FR   = FR;
    trial.annoFR        = FR;
    trial.stim          = stim;
    trial.annot         = annot;
    saveAnnotSheetTxt({movieNames},trial,[],1);
    disp('   done!');
end




