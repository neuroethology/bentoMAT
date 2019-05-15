function concatAnnot(varargin)
% function concatAnnot([pth],file1,file2,...)
%
% input: list of annotation files (full paths) OR a directory name + list
% of annotations as relative paths in that directory.
% output: saves a new .annot file in which the contents of file1,file2,...
% are combined in order listed.
%
% Example usage:
% concatAnnot('C:\users\bento\documents\file1.annot','C:\users\bento\documents\file2.annot');
% concatAnnot('C:\users\bento\documents\','file1.annot','file2.annot');
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

annotComp = struct();
bump = 0;
if(isdir(varargin{1})) %allow relative paths if the first input is the parent directory
    pth = varargin{1};
    start=2;
else
    pth = fileparts(varargin{1});
    start=1;
end
pth = strrep(strrep(pth,'/',filesep),'\',filesep);
if(pth(end)~=filesep)
    pth = [pth filesep];
end
for f = varargin(start:end)
    [annotations,tmax,tmin,FR,~,~] = loadAnyAnnot([pth f{:}]);
    
    if(isempty(fieldnames(annotComp)))
        annotComp = annotations;
        bump = tmax;
        FR0 = FR;
        tmin0 = tmin;
        continue;
    end
    sc = FR0/FR;
        
    for ch = fieldnames(annotations)'
        if(~isfield(annotComp,ch{:}))
            annotComp.(ch{:}) = struct();
        end
        for b = fieldnames(annotations.(ch{:}))'
            if(~isfield(annotComp.(ch{:}),b{:}))
                annotComp.(ch{:}).(b{:}) = [];
            end
            annotComp.(ch{:}).(b{:}) = [annotComp.(ch{:}).(b{:}); round(annotations.(ch{:}).(b{:})*sc)+tmin-1+bump];
        end
    end
    bump=bump+round(tmax*sc);
end

trial.io.annot.fid  = [];
trial.io.annot.tmin = tmin0;
trial.io.annot.tmax = bump;
trial.io.annot.FR   = FR0;
trial.annot         = annotComp;
trial.annoFR        = FR0;
trial.stim          = '';

saveAnnotSheetTxt([],trial,[pth 'combined_annotations.annot']);
