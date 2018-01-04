function gui = transferAnnot(gui,data)
% copies information regarding the current set of annotations into a format
% the gui understands.
annot = gui.annot;

cmap = annot.cmapDef;
used = [0 0 0;1 1 1];
for f = fieldnames(cmap)'
    used = [used;cmap.(f{:})];
end

channels = fieldnames(data.annot);
annot.channels = channels;
if(isempty(annot.activeCh))
    annot.activeCh = annot.channels{1};
end
gui.ctrl.annot.ch.String = {channels{:},'add new...','remove channel...'};
bhvList = fieldnames(data.annot.(annot.activeCh))';
bhvList(strcmpi(bhvList,'other'))=[];

annot.bhv = struct();
for f = bhvList
    if(~isempty(annot.activeCh)) %if one of the annotation channels is being displayed
        annot.bhv.(f{:}) = convertToRast(data.annot.(annot.activeCh).(f{:}),length(data.annoTime));
    else
        annot.bhv.(f{:}) = false(1,length(data.annoTime));
    end
    if(~isfield(annot.show,f{:}))
        annot.show.(f{:}) = 1;
    end
    if(isfield(cmap,f{:}))
        annot.cmap.(f{:}) = cmap.(f{:});
    else
        annot.cmap.(f{:}) = distinguishable_colors(1,used);
        annot.cmapDef.(f{:}) = annot.cmap.(f{:});
        used = [used; annot.cmap.(f{:})];
        updatePreferredCmap(annot.cmapDef);
    end
end
gui.annot = annot;

if(gui.ctrl.annot.annot.Value > length(bhvList))
    gui.ctrl.annot.annot.Value = 1;
end
gui.ctrl.annot.annot.String = {bhvList{:},'add new...','remove field...'};