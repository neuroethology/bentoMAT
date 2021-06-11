function gui = readoutAnnot(gui)
% take current annotations from the annot struct and put them back into
% the appropriate channel of gui.data
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(isempty(gui.annot.activeCh)|~gui.annot.modified)
    return;
end

bhv = gui.annot.bhv;
bhvStruct = struct();
for f = fieldnames(bhv)'
    bhvStruct.(f{:}) = convertToBouts(bhv.(f{:}));
end
gui.data.annot.(gui.annot.activeCh) = bhvStruct;