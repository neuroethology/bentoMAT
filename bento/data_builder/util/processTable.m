function processTable(source,~,parent)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


gui = guidata(source);

[M,flag] = packExperiment(gui);
if(flag)
    return;
end

transferExptToGui(M,parent);

close(gui.f);