function [annot, tmin, tmax, allFR, fid, fidSave] = unpackAnnotFromLoader(pth, annoList,startAnno,stopAnno,subFrames)
% annoList   -> data{i,match.Annotation_file}
% startAnno  -> data{i,match.Start_Anno}
% stopAnno   -> data{i,match.Stop_Anno}
% subFrames  -> raw{1,9}
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



annoList    = strsplit(annoList,';');
tmin        = zeros(1,length(annoList));
tmax        = zeros(1,length(annoList));
allFR       = struct();
fid         = cell(1,length(annoList));
fidSave     = cell(1,length(annoList));
annot       = struct();

for j = 1:length(annoList)
    annoList{j} = strtrim(strip(strip(annoList{j},'left','.'),'left',filesep));
    if(length(annoList)==1)
        suff = '';
    else
        suff = ['_file' num2str(j,'%02d')];
    end

    % unpack the annotations
    if(subFrames), [atemp,tmax(j),tmin(j),FR,fid{j},~] = loadAnyAnnot([pth annoList{j}],startAnno,stopAnno);
    else,          [atemp,tmax(j),tmin(j),FR,fid{j},~] = loadAnyAnnot([pth annoList{j}]);
    end
    
    % generate a filename to save modified annotations
    [~,~,ext] = fileparts(annoList{j});
    if(subFrames), fidSave{j} = strrep([pth annoList{j}],ext,['_' num2str(tmax(j)) '-' num2str(tmax(j)) '.annot']);
    else,          fidSave{j} = strrep([pth annoList{j}],ext,'.annot');
    end
    fidSave{j} = strrep([pth annoList{j}],'.txt','.annot');

    % keep track of framerates
    for f = fieldnames(atemp)'
        allFR.([f{:} suff]) = FR;
    end

    % add channel to annot structure
    atemp  = rmBlankChannels(atemp);
    fields = fieldnames(atemp);
    for f = 1:length(fields)
        annot.([fields{f} suff]) = atemp.(fields{f});
    end
end
