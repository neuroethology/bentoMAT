function setBentoPth(source,~,parent,doPrompt)

exptGui = guidata(source);
if(doPrompt)
    pth = uigetdir(exptGui.root.String,'Select parent directory of your data');
    if(~pth) % no directory selected
        return;
    end
else
    pth = exptGui.root.String;
end

exptGui.root.String = pth; % sets path within the data builder
parent.pth          = pth; % saves the path in bento so it can be reused
guidata(parent.h0,parent);