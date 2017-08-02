function findFiles(source,~)

gui = guidata(source);

pth = get(gui.root,'string');
if(~strcmpi(pth(end),filesep))
    pth = [pth filesep];
end

caStr  = get(gui.Castr,'string');
caFiles = rdir([pth '**' filesep caStr]);
caFiles = {caFiles.name};

caFiles     = strrep(caFiles,pth,'');
caFiles(strcmpi(caFiles,['.' filesep]))       = [];
caFiles(strcmpi(caFiles,['..' filesep]))      = [];
set(gui.tCa,'data',caFiles');
