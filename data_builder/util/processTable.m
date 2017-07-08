function processTable(source,~,parent)
gui = guidata(source);

[M,flag] = packExperiment(gui);
if(flag)
    return;
end

transferExptToGui(M,parent);

close(gui.f);