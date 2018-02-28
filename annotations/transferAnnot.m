function gui = transferAnnot(gui,data)
% copies information regarding the current set of annotations into a format
% the gui understands.
annot = gui.annot;

cmap    = annot.cmapDef;
hotkeys = annot.hotkeysDef;
used = [0 0 0;1 1 1];
for f = fieldnames(cmap)'
    used = [used;cmap.(f{:})];
end

channels = fieldnames(data.annot);
annot.channels = channels;
bhvList = {};
for ch = channels'
    bhvList = [bhvList fieldnames(data.annot.(ch{:}))'];
end
bhvList(strcmpi(bhvList,'other'))=[];


gui.ctrl.annot.ch.Value = find(strcmpi(channels,annot.activeCh));
if(isempty(gui.ctrl.annot.ch.Value))
    gui.ctrl.annot.ch.Value = 1;
    annot.activeCh = [];
end
if(isempty(annot.activeCh))
    if(~isempty(channels))
        annot.activeCh = channels{1};
    else
        annot.activeCh='';
        channels = {''};
    end
end
gui.ctrl.annot.ch.String = channels;


annot.bhv        = struct();
annot.cmap       = struct();
annot.hotkeys    = struct();

flag = 0;
for f = bhvList
    % if the behavior is in the active channel
    if(~isempty(annot.activeCh) && isfield(data.annot.(annot.activeCh),f{:}))
        annot.bhv.(f{:}) = convertToRast(data.annot.(annot.activeCh).(f{:}),length(data.annoTime));
    end
    % for all behaviors
    if(~isfield(annot.show,f{:}))
        annot.show.(f{:}) = 1;
    end
    
    if(isfield(cmap,f{:}))
        annot.cmap.(f{:})       = cmap.(f{:});
    else
        annot.cmap.(f{:})       = distinguishable_colors(1,used);
        annot.cmapDef.(f{:})    = annot.cmap.(f{:});
        used = [used; annot.cmap.(f{:})];
        flag = 1;
    end
    
    if(isfield(hotkeys,f{:}) && ~strcmpi(hotkeys.(f{:}),'_'))
        annot.hotkeys.(hotkeys.(f{:})) = f{:};
    else
        annot.hotkeysDef.(f{:}) = '_'; %default if no hotkey is assigned
        flag = 1;
    end
end

if(flag)
    updatePreferredCmap(annot.cmapDef,annot.hotkeysDef);
end
gui.annot = annot;


