function addFile(source,~,doOverwrite)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui = guidata(source);

if(isempty(gui.t.UserData)||isempty(gui.tCa.UserData))
    msgbox('Select text to transfer + destination cells');
    return;
end

if(size(gui.t.UserData,1)==size(gui.tCa.UserData,1))
    if(doOverwrite||isempty(gui.t.Data(gui.t.UserData(:,1),gui.t.UserData(:,2))))
        gui.t.Data(gui.t.UserData(:,1),gui.t.UserData(:,2)) = ...
            gui.tCa.Data(gui.tCa.UserData(:,1),gui.tCa.UserData(:,2));
    else
        for i=1:size(gui.t.UserData,1)
            gui.t.Data{gui.t.UserData(i,1),gui.t.UserData(i,2)} = ...
                [gui.t.Data{gui.t.UserData(i,1),gui.t.UserData(i,2)} ';'...
                 gui.tCa.Data{gui.tCa.UserData(i,1),gui.tCa.UserData(i,2)}];
        end
    end
elseif(size(gui.tCa.UserData,1)==1)
    if(doOverwrite||isempty(gui.t.Data(gui.t.UserData(:,1),gui.t.UserData(:,2))))
        gui.t.Data(gui.t.UserData(:,1),gui.t.UserData(:,2)) = ...
            gui.tCa.Data(gui.tCa.UserData(:,1),gui.tCa.UserData(:,2));
    else
        for i=1:size(gui.t.UserData,1)
            gui.t.Data(gui.t.UserData(i,1),gui.t.UserData(i,2)) = ...
                [gui.t.Data{gui.t.UserData(i,1),gui.t.UserData(i,2)} ';'...
                 gui.tCa.Data{gui.tCa.UserData(1,1),gui.tCa.UserData(1,2)}];
        end
    end
end

guidata(source,gui);