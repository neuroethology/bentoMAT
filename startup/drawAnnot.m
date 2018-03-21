function gui = drawAnnot(gui)

%initialize labels
annot.channels      = '';
annot.activeCh      = '';
annot.activeBeh     = '';
annot.modified      = 0;
annot.highlighting  = 0;
annot.prev          = [];
annot.bhv           = struct();
annot.show          = struct();
annot.cmap          = struct();
annot.hotkeys       = struct();
annot.highlightStart=[];
[annot.cmapDef, annot.hotkeysDef] = loadPreferredCmap(); %default colors/hotkeys to use

% adds patches to show annotation edits on the trace/tracker axes
annot.Box.traces     = patch([0 0 0 0],[0 0 0 0],[.8 .8 .8],...
                        'parent',gui.traces.axes,'visible','off');
annot.Box.fineAnnot  = patch([0 0 0 0],[0 0 0 0],[.8 .8 .8],...
                        'parent',gui.fineAnnot.axes,'visible','off');

gui.annot = annot;