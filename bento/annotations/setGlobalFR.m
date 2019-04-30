function [FR,annot] = setGlobalFR(allFR,annot,defaultFR)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


FRlist = [];
for f = fieldnames(allFR)'
    if(isnan(allFR.(f{:})))
        allFR.(f{:}) = defaultFR;
    end
    FRlist(end+1) = allFR.(f{:});
end

FR = max(FRlist);

% now set all channels to the master sampling rate
for f = fieldnames(annot)'
    for beh = fieldnames(annot.(f{:}))'
        annot.(f{:}).(beh{:}) = round(annot.(f{:}).(beh{:}) * (FR/allFR.(f{:})));
    end
end