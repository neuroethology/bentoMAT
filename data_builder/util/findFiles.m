function findFiles(source,~)

gui = guidata(source);

pth = get(gui.root,'string');
if(~strcmpi(pth(end),'\'))
    pth = [pth '\'];
end

caStr  = get(gui.Castr,'string');
caFiles = rdir([pth '**\' caStr]);
caFiles = {caFiles.name};

caFiles     = strrep(caFiles,pth,'');
caFiles(strcmpi(caFiles,'.\'))       = [];
caFiles(strcmpi(caFiles,'..\'))      = [];
set(gui.tCa,'data',caFiles');
