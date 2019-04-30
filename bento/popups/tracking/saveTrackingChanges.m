function saveTrackingChanges(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



h    = guidata(source);
gui  = guidata(h.guifig);

[FileName,PathName] = uiputfile();
adjustments = gui.data.tracking.active;
save([PathName FileName],'adjustments');