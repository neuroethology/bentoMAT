function annot = mergeHotkeys(annot,hotkeys)

for f = fieldnames(hotkeys)'
    annot.hotkeysDef.(f{:}) = hotkeys.(f{:});
end
updatePreferredCmap(annot.cmapDef,annot.hotkeysDef);