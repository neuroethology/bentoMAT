function addFile(source,~)

gui = guidata(source);

if(isempty(gui.t.UserData)|isempty(gui.tCa.UserData))
    msgbox('Select text to transfer + destination cells');
    return;
end

if(size(gui.t.UserData,1)==size(gui.tCa.UserData,1))
    gui.t.Data(gui.t.UserData(:,1),gui.t.UserData(:,2)) = ...
        gui.tCa.Data(gui.tCa.UserData(:,1),gui.tCa.UserData(:,2));
end

guidata(source,gui);