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
    rast    = [bhv.(f{:})(1) bhv.(f{:})(2:end)-bhv.(f{:})(1:end-1) -bhv.(f{:})(end)];
    tOn     = find(rast==1);
    tOff    = find(rast==-1);
    if(~isempty(tOn)&~isempty(tOff))
        bhvStruct.(f{:}) = [tOn' tOff'-1];
    else
        bhvStruct.(f{:}) = [];
    end
end
gui.data.annot.(gui.annot.activeCh) = bhvStruct;