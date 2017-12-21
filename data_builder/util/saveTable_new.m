function saveTable_new(source,~)
gui = guidata(source);

mouse = gui.mouse;
gui.pth = strrep(gui.pth,'/',filesep);
gui.pth = strrep(gui.pth,'\',filesep);
if(gui.pth(end)~=filesep)
    gui.pth = [gui.pth filesep];
end
% and save!
[FileName,PathName] = uiputfile([gui.pth '.mat']);
if(~FileName)
    return;
end
save([PathName FileName],'mouse');