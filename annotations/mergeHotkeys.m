function annot = mergeHotkeys(annot,hotkeys)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



for f = fieldnames(hotkeys)'
    annot.hotkeysDef.(f{:}) = hotkeys.(f{:});
end
updatePreferredCmap(annot.cmapDef,annot.hotkeysDef);